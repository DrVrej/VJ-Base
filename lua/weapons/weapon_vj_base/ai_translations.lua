if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

function SWEP:SetupWeaponHoldTypeForAI(htype)
	-- Yete NPC-en Rebel-e, ere vor medz zenki animation-ere kordzadze yerp vor ge kalegor
	local bezdigZenk_Kalel = ACT_WALK_AIM_PISTOL
	local bezdigZenk_Vazel = ACT_RUN_AIM_PISTOL
	if self.NPC_AnimationSet == "Rebel" then
		bezdigZenk_Kalel = ACT_WALK_AIM_RIFLE
		bezdigZenk_Vazel = ACT_RUN_AIM_RIFLE
	end
	
	-- Yete NPC-en Combine-e yev bizdig zenk pernere, ere vor medz zenki animation-ere kordzadze
	local rifleOverride = false
	local medzZenk_Genal = ACT_IDLE_SMG1
	local medzZenk_Kalel = ACT_WALK_RIFLE
	if self.NPC_AnimationSet == "Combine" && (htype == "pistol" or htype == "revolver") then
		rifleOverride = true
		medzZenk_Genal = VJ_SequenceToActivity(self:GetOwner(),"idle_unarmed")
		medzZenk_Kalel = VJ_SequenceToActivity(self:GetOwner(),"walkunarmed_all")
	end
	
	-- Yete NPC-en Metrocop-e gamal Rebel-e, ere vor medz zenki animation-ere kordzadze yerp vor ge kalegor
	local bonbakshen_varichadz = ACT_RANGE_ATTACK_SHOTGUN_LOW
	local bonbakshen_Kalel = ACT_WALK_AIM_SHOTGUN
	local bonbakshen_Vazel = ACT_RUN_AIM_SHOTGUN
	if self.NPC_AnimationSet == "Metrocop" or self.NPC_AnimationSet == "Rebel" then
		bonbakshen_varichadz = ACT_RANGE_ATTACK_SMG1_LOW
		onbakshen_Kalel = ACT_WALK_AIM_RIFLE
		bonbakshen_Vazel = ACT_RUN_AIM_RIFLE
	end
	
	self.ActivityTranslateAI = {}
	if rifleOverride == true or htype == "ar2" or htype == "smg" then
		if htype == "ar2" or rifleOverride == true then
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_AR2
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_AR2
			self.ActivityTranslateAI[ACT_RANGE_AIM_LOW] 				= ACT_RANGE_AIM_AR2_LOW
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_AR2_LOW
		elseif htype == "smg" then
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ACT_RANGE_AIM_LOW] 				= ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SMG1_LOW
		end
		self.ActivityTranslateAI[ACT_COVER_LOW] 					= ACT_COVER_SMG1_LOW
		self.ActivityTranslateAI[ACT_RELOAD] 						= ACT_RELOAD_SMG1
		self.ActivityTranslateAI[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
		self.ActivityTranslateAI[ACT_GESTURE_RELOAD] 				= ACT_GESTURE_RELOAD_SMG1
		self.ActivityTranslateAI[ACT_IDLE] 							= medzZenk_Genal
		self.ActivityTranslateAI[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI[ACT_IDLE_RELAXED] 					= ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI[ACT_IDLE_STIMULATED] 				= ACT_IDLE_SMG1_STIMULATED
		self.ActivityTranslateAI[ACT_IDLE_AGITATED] 				= ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED] 				= ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED] 			= ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED] 			= ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI[ACT_WALK] 							= medzZenk_Kalel
		self.ActivityTranslateAI[ACT_WALK_AIM] 						= ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ACT_WALK_RELAXED] 					= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI[ACT_WALK_STIMULATED] 				= ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_WALK_AGITATED] 				= ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED] 				= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED] 			= ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED] 			= ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN] 							= ACT_RUN_RIFLE
		self.ActivityTranslateAI[ACT_RUN_AIM] 						= ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN_RELAXED] 					= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI[ACT_RUN_STIMULATED] 				= ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_RUN_AGITATED] 					= ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED] 				= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED] 			= ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED] 				= ACT_RUN_AIM_RIFLE
	elseif htype == "crossbow" or htype == "shotgun" then
		self.ActivityTranslateAI[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_SHOTGUN
		self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_SHOTGUN
		self.ActivityTranslateAI[ACT_RANGE_AIM_LOW] 				= ACT_RANGE_AIM_AR2_LOW
		self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW] 			= bonbakshen_varichadz
		self.ActivityTranslateAI[ACT_COVER_LOW] 					= ACT_COVER_SMG1_LOW
		self.ActivityTranslateAI[ACT_RELOAD] 						= ACT_RELOAD_SHOTGUN
		self.ActivityTranslateAI[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW //ACT_RELOAD_SHOTGUN_LOW
		self.ActivityTranslateAI[ACT_GESTURE_RELOAD] 				= ACT_GESTURE_RELOAD_SHOTGUN
		self.ActivityTranslateAI[ACT_IDLE] 							= ACT_SHOTGUN_IDLE4
		self.ActivityTranslateAI[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_SHOTGUN
		self.ActivityTranslateAI[ACT_IDLE_RELAXED] 					= ACT_IDLE_SHOTGUN_RELAXED
		self.ActivityTranslateAI[ACT_IDLE_STIMULATED] 				= ACT_IDLE_SHOTGUN_STIMULATED
		self.ActivityTranslateAI[ACT_IDLE_AGITATED] 				= ACT_IDLE_SHOTGUN_AGITATED
		self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED] 				= ACT_SHOTGUN_IDLE_DEEP
		self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED] 			= ACT_SHOTGUN_IDLE_DEEP
		self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED] 			= ACT_SHOTGUN_IDLE_DEEP
		self.ActivityTranslateAI[ACT_WALK] 							= ACT_WALK_AIM_SHOTGUN
		self.ActivityTranslateAI[ACT_WALK_AIM] 						= onbakshen_Kalel
		self.ActivityTranslateAI[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ACT_WALK_RELAXED] 					= ACT_WALK_AIM_SHOTGUN
		self.ActivityTranslateAI[ACT_WALK_STIMULATED] 				= ACT_WALK_AIM_SHOTGUN
		self.ActivityTranslateAI[ACT_WALK_AGITATED] 				= ACT_WALK_AIM_SHOTGUN
		self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED] 				= ACT_WALK_AIM_SHOTGUN
		self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED] 			= ACT_WALK_AIM_SHOTGUN
		self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED] 			= ACT_WALK_AIM_SHOTGUN
		self.ActivityTranslateAI[ACT_RUN] 							= ACT_RUN_RIFLE
		self.ActivityTranslateAI[ACT_RUN_AIM] 						= bonbakshen_Vazel
		self.ActivityTranslateAI[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN_RELAXED] 					= ACT_RUN_RIFLE
		self.ActivityTranslateAI[ACT_RUN_STIMULATED] 				= ACT_RUN_RIFLE
		self.ActivityTranslateAI[ACT_RUN_AGITATED] 					= ACT_RUN_RIFLE
		self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED] 				= ACT_RUN_AIM_SHOTGUN
		self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED] 			= ACT_RUN_AIM_SHOTGUN
		self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED] 				= ACT_RUN_AIM_SHOTGUN
	elseif htype == "rpg" then
		self.ActivityTranslateAI[ACT_RANGE_ATTACK1] 				= ACT_CROUCHIDLE
		self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_SMG1
		self.ActivityTranslateAI[ACT_RANGE_AIM_LOW] 				= ACT_RANGE_AIM_SMG1_LOW
		self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_SMG1_LOW
		self.ActivityTranslateAI[ACT_COVER_LOW] 					= ACT_COVER_LOW_RPG
		self.ActivityTranslateAI[ACT_RELOAD] 						= ACT_RELOAD_SMG1
		self.ActivityTranslateAI[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
		self.ActivityTranslateAI[ACT_GESTURE_RELOAD] 				= ACT_GESTURE_RELOAD_SMG1
		self.ActivityTranslateAI[ACT_IDLE] 							= ACT_IDLE_RPG
		self.ActivityTranslateAI[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_RPG
		self.ActivityTranslateAI[ACT_IDLE_RELAXED] 					= ACT_IDLE_RPG_RELAXED
		self.ActivityTranslateAI[ACT_IDLE_STIMULATED] 				= ACT_IDLE_SMG1_STIMULATED
		self.ActivityTranslateAI[ACT_IDLE_AGITATED] 				= ACT_IDLE_ANGRY_RPG
		self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED] 				= ACT_IDLE_RPG_RELAXED
		self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED] 			= ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED] 			= ACT_IDLE_ANGRY_RPG
		self.ActivityTranslateAI[ACT_WALK] 							= ACT_WALK_RPG
		self.ActivityTranslateAI[ACT_WALK_AIM] 						= ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RPG
		self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_RPG
		self.ActivityTranslateAI[ACT_WALK_RELAXED] 					= ACT_WALK_RPG_RELAXED
		self.ActivityTranslateAI[ACT_WALK_STIMULATED] 				= ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_WALK_AGITATED] 				= ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED] 				= ACT_WALK_RPG_RELAXED
		self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED] 			= ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED] 			= ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN] 							= ACT_RUN_RPG
		self.ActivityTranslateAI[ACT_RUN_AIM] 						= ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RPG
		self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_RPG
		self.ActivityTranslateAI[ACT_RUN_RELAXED] 					= ACT_RUN_RPG_RELAXED
		self.ActivityTranslateAI[ACT_RUN_STIMULATED] 				= ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_RUN_AGITATED] 					= ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED] 				= ACT_RUN_RPG_RELAXED
		self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED] 			= ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED] 				= ACT_RUN_AIM_RIFLE
	else
		-- revolver or pistol
		self.ActivityTranslateAI[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK_PISTOL
		self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1] 		= ACT_GESTURE_RANGE_ATTACK_PISTOL
		self.ActivityTranslateAI[ACT_RANGE_AIM_LOW] 				= ACT_RANGE_AIM_PISTOL_LOW
		self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK_PISTOL_LOW
		self.ActivityTranslateAI[ACT_COVER_LOW] 					= ACT_COVER_PISTOL_LOW
		self.ActivityTranslateAI[ACT_RELOAD] 						= ACT_RELOAD_PISTOL
		self.ActivityTranslateAI[ACT_RELOAD_LOW] 					= ACT_RELOAD_PISTOL_LOW
		self.ActivityTranslateAI[ACT_GESTURE_RELOAD] 				= ACT_GESTURE_RELOAD_PISTOL
		self.ActivityTranslateAI[ACT_IDLE] 							= ACT_IDLE_PISTOL
		self.ActivityTranslateAI[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_PISTOL
		/*self.ActivityTranslateAI[ACT_IDLE_RELAXED] 				= ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI[ACT_IDLE_STIMULATED] 				= ACT_IDLE_SMG1_STIMULATED
		self.ActivityTranslateAI[ACT_IDLE_AGITATED] 				= ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED] 				= ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED] 			= ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED] 			= ACT_IDLE_ANGRY_SMG1*/
		self.ActivityTranslateAI[ACT_WALK] 							= ACT_WALK_PISTOL
		self.ActivityTranslateAI[ACT_WALK_AIM] 						= bezdigZenk_Kalel
		/*self.ActivityTranslateAI[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ACT_WALK_RELAXED] 					= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI[ACT_WALK_STIMULATED] 				= ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_WALK_AGITATED] 				= ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED] 				= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED] 			= ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED] 			= ACT_WALK_AIM_RIFLE*/
		self.ActivityTranslateAI[ACT_RUN] 							= ACT_RUN_PISTOL
		self.ActivityTranslateAI[ACT_RUN_AIM] 						= bezdigZenk_Vazel
		/*self.ActivityTranslateAI[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN_RELAXED] 					= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI[ACT_RUN_STIMULATED] 				= ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_RUN_AGITATED] 					= ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED] 				= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED] 			= ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED] 				= ACT_RUN_AIM_RIFLE*/
	end
	return
end