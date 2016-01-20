local function run(msg)
local bot_id = 165943175
if msg.action and msg.action.type then
if msg.action.type == 'chat_add_user' and msg.action.user.id == bot_id then
chat_del_user('chat#id'..msg.to.id, 'user#id'..bot_id, ok_cb, true)
end
end
end

return {
description = "Plugin to delete him self from groups.", 
usage = {},
patterns = {"^!!tgservice (.+)$"}, 
run = run
}
-- https://github.com/amirhmz
-- https://telegram.me/AmirDark
