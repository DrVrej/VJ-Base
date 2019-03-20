/*--------------------------------------------------
	=============== Server Side Functions ===============
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

require("ai_vj_schedule")
local getsched = ai_vj_schedule.New -- Pervent stack overflow
function ai_vj_schedule.New(name)
	local actualsched = getsched(name)
	actualsched.Name = name
	return actualsched
end