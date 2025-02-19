/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if CLIENT then return end

module("vj_ai_nodegraph", package.seeall)

local Nodegraph		= {}
Nodegraph.__index 	= Nodegraph

Nodegraph.Data = nil

-- ENUMs
Nodegraph.NODE_TYPE_ANY = 0
Nodegraph.NODE_TYPE_DELETED = 1
Nodegraph.NODE_TYPE_GROUND = 2
Nodegraph.NODE_TYPE_AIR = 3
Nodegraph.NODE_TYPE_CLIMB = 4
Nodegraph.NODE_TYPE_WATER = 5
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Gets the map's nodegraph data and returns it as a Lua table with all the info! | WARNING: This is an internal function, causes major lag! AVOID CALLING!
	Returns
		- table, full nodegraph data generated from .ain file
	
	Based on the following:
	- https://developer.valvesoftware.com/wiki/.ain
	- https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_networkmanager.cpp#L475
-----------------------------------------------------------]]
local z32768 = Vector(0, 0, 32768)
local AINET_VERSION_NUMBER = 37
local NUM_HULLS = 10 -- NUM_HULLS is set to 10 for most maps tested
--
function Nodegraph:ReadNodegraph()
	local FILE = file.Open("maps/graphs/" .. game.GetMap() .. ".ain", "rb", "GAME")
	local nodegraphData = {Version = -1, NodeCount = 0, Nodes = {}, LinkCount = 0, Links = {}}
	if !FILE then MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Nodegraph module]: ", VJ.COLOR_RED, "Nodegraph file couldn't be found!\n") return nodegraphData end -- File doesn't exist

	-- struct ain_header
	if FILE:ReadLong() == AINET_VERSION_NUMBER then -- AI Net version
		nodegraphData.Version = FILE:ReadLong() -- Map version
		
	-- struct ain_node
		local num_nodes = FILE:ReadLong()
		nodegraphData.NodeCount = num_nodes
		for i = 0, num_nodes - 1 do
			local pos = Vector(FILE:ReadFloat(), FILE:ReadFloat(), FILE:ReadFloat()) -- 3 floats (x, y, z)
			local yaw = FILE:ReadFloat()
			local flOffsets = {}
			for _ = 1, NUM_HULLS do
				table.insert(flOffsets, FILE:ReadFloat())
			end
			local nodeType = FILE:ReadByte()
			local nodeInfo = FILE:ReadUShort()
			local zone = FILE:ReadShort()
			-- Find water level and its contents
			local waterLevel = -1
			local waterSurfacePos = pos
			local waterContent = -1
			local posContents = util.PointContents(pos)
			if bit.band(posContents, CONTENTS_SLIME) == CONTENTS_SLIME then -- Slime / acid waters
				waterContent = CONTENTS_SLIME
			elseif bit.band(posContents, CONTENTS_WATER) == CONTENTS_WATER then -- Regular water
				waterContent = CONTENTS_WATER
			end
			if waterContent != -1 then -- If a water was found..
				-- Do a trace up until it hits something
				-- Then do a trace back to the node pos, this will find the surface of the water!
				local tr1 = util.TraceLine({
					start = pos,
					endpos = pos + z32768,
					mask = MASK_WATER
				})
				local tr2 = util.TraceLine({
					start = tr1.HitPos,
					endpos = pos,
					mask = MASK_WATER
				})
				waterLevel = pos:Distance(tr2.HitPos)
				waterSurfacePos = tr2.HitPos
			end
			nodegraphData.Nodes[i] = {
				id = i, -- Node's ID
				pos = pos, -- Node's position
				yaw = yaw, -- The y angle the NPC should when on this node (Usually a hint or climb node)
				flags = flOffsets, -- Vertical offset for each hull type, assuming ground node, 0 otherwise
				--[[
					1 = Force human permission				(1)
					2 = Force small_centered permission		(2)
					3 = Force wide_human permission			(4)
					4 = Force tiny permission				(8)
					5 = Force wide_short permission			(16)
					6 = Force medium permission				(32)
					7 = Force tiny_centered permission		(64)
					8 = Force large permission				(128)
					9 = Force large_centered permission		(256)
					10 = Keep editor position				(512)
				]]--
				type = nodeType, -- Node type
				--[[
					0 = NODE_ANY,		-- Used to specify any type of node (for search)
					1 = NODE_DELETED,	-- Used in wc_edit mode to remove nodes during runtime
					2 = NODE_GROUND,
					3 = NODE_AIR,
					4 = NODE_CLIMB,
					5 = NODE_WATER
				]]--
				info = nodeInfo, -- Extra info about the node
				--[[
					NODE_CLIMB_BOTTOM		=	1			-- Node at bottom of ladder
					NODE_CLIMB_ON			=	2			-- Node on ladder somewhere
					NODE_CLIMB_OFF_FORWARD =	4			-- Dismount climb by going forward
					NODE_CLIMB_OFF_LEFT		=	8			-- Dismount climb by going left
					NODE_CLIMB_OFF_RIGHT	=	16			-- Dismount climb by going right
					NODE_CLIMB_EXIT			=	bits_NODE_CLIMB_OFF_FORWARD | bits_NODE_CLIMB_OFF_LEFT | bits_NODE_CLIMB_OFF_RIGHT,
					DONT_DROP				=	16384,		-- Don't drop node on map initialize
					NODE_WC_NEED_REBUILD	=	268435456,	-- Used to more nodes in WC edit mode
					NODE_WC_CHANGED			=	536870912,	-- Node changed during WC edit
					NODE_WONT_FIT_HULL		=	1073741824,	-- Used only for debug display
					NODE_FALLEN				=	2147483648,	-- Fell through the world during initialization
				]]--
				zone = zone,
				--[[
					0 = AI_NODE_ZONE_UNKNOWN	-- No zone is set for this node
					1 = AI_NODE_ZONE_SOLO		-- This node is alone without other nodes in its zone
					3 = AI_NODE_ZONE_UNIVERSAL	-- Specifies that the node needs a rebuild?
					4 = AI_NODE_FIRST_ZONE		-- First zone, anything greater is incremented
					4+ 							-- Group of zones (Incremented starting at AI_NODE_FIRST_ZONE)
				]]--
				linkIDs = {}, -- Link IDs
				WCLookupID = -1, -- World edit lookup ID | -1 = No WC lookup ID found
				waterLevel = waterLevel, -- Node's water level, distance from the node to the top of the water | -1 = Node is not in water
				waterSurfacePos = waterSurfacePos, -- Top of the water surface (Where the water trace hit)
				waterContent = waterContent -- Water's content (CONTENTS_SLIME or CONTENTS_WATER) | -1 = Node is not in water
			}
		end

	-- struct ain_link
		local num_links = FILE:ReadLong()
		nodegraphData.LinkCount = num_links
		for i = 1, num_links do
			local srcId = FILE:ReadShort()
			local distId = FILE:ReadShort()
			local moves = {}
			for _ = 1, NUM_HULLS do
				table.insert(moves, FILE:ReadByte())
			end
			nodegraphData.Links[i] = {
				srcNodeID = srcId,			-- The node that 'owns' this link
				distNodeID = distId,		-- The node on the other end of the link
				acceptedMoveTypes = moves 	-- Capabilities ( CAP_* ) allowed for each hull type
			}
			table.insert(nodegraphData.Nodes[srcId].linkIDs, i)
			table.insert(nodegraphData.Nodes[distId].linkIDs, i)
		end

	-- struct ain_lookup
		for i = 0, num_nodes - 1 do -- Table of WC ID's to Engine ID's
			nodegraphData.Nodes[i].WCLookupID = FILE:ReadLong()
		end
	end

	FILE:Close()
	return nodegraphData
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Initialize the Nodegraph object | WARNING: This is an internal function, avoid using!
-----------------------------------------------------------]]
function Nodegraph:Init()
	MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Nodegraph module]: ", VJ.COLOR_SERVER, "Object created.\n")
	self.Data = self:ReadNodegraph()
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Get the nodegraph table
	Returns
		- table, all the nodegraph data
-----------------------------------------------------------]]
function Nodegraph:GetNodegraph()
	return self.Data
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Returns whether or not a nodegraph was found
	Returns
		- bool, true if a nodegraph exists
-----------------------------------------------------------]]
function Nodegraph:Exists()
	return self.Data.NodeCount > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Get a node's data by its ID
		- nodeID = The node ID to search for in the nodes table
	Returns
		- table, the given node's data
-----------------------------------------------------------]]
function Nodegraph:GetNode(nodeID)
	return self.Data.Nodes[nodeID]
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Get a link's data by its ID
		- linkID = The link ID to search for in the links table
	Returns
		- table, the given link's data
-----------------------------------------------------------]]
function Nodegraph:GetLink(linkID)
	return self.Data.Links[linkID]
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Get the nearest node to the given position
		- pos = Position to find the closest node to
		- nodeType = Restrict to only look for nodes with this type
	Returns
		- table, node's data
-----------------------------------------------------------]]
function Nodegraph:GetNearestNode(pos, nodeType)
	nodeType = nodeType or self.NODE_TYPE_ANY
	local anyType = nodeType == self.NODE_TYPE_ANY
	local nearestNode = nil
	local closestDist = 99999
	for _, data in pairs(self.Data.Nodes) do -- Future readers: Starts at 0, so can NOT use "ipairs"!
		if anyType or (nodeType == data.type) then
			local dist = data.pos:Distance(pos)
			if dist < closestDist then
				nearestNode = data
				closestDist = dist
			end
		end
	end
	return nearestNode
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Creates a new Nodegraph object
	Returns
		- Nodegraph object
-----------------------------------------------------------]]
function New()
	local newNodegraph = {}
	setmetatable(newNodegraph, Nodegraph)
	newNodegraph:Init()
	return newNodegraph
end

MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Nodegraph module]: ", VJ.COLOR_SERVER, "Successfully initialized!\n")