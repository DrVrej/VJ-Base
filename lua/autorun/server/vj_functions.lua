/*--------------------------------------------------
	=============== Server Side Functions ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load server side functions autorun codes for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

require("ai_vj_schedule")
local getsched = ai_vj_schedule.New -- Pervent stackoverflow
function ai_vj_schedule.New(name)
	local actualsched = getsched(name)
	actualsched.Name = name
	return actualsched
end