do


local function action_by_reply(extra, success, result)
  local user_info = {}
  local uhash = 'user:'..result.from.id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..result.from.id..':'..result.to.id
  user_info.msgs = tonumber(redis:get(um_hash) or 0)
  user_info.name = user_print_name(user)..' ['..result.from.id..']'
  local msgs = '› تعداد پیام ارسالی : '..user_info.msgs
  if result.from.username then
    user_name = '@'..result.from.username
  else
    user_name = ''
  end
  local msg = result
  local user_id = msg.from.id
  local chat_id = msg.to.id
  local user = 'user#id'..msg.from.id
  local chat = 'chat#id'..msg.to.id
  local data = load_data(_config.moderation.data)
  if data[tostring('admins')][tostring(user_id)] then
    who = '🏵 مدیر ربات'
  elseif data[tostring(msg.to.id)]['moderators'][tostring(user_id)] then
    who = '👮🏻 مدیر گروه'
  elseif data[tostring(msg.to.id)]['set_owner'] == tostring(user_id) then
    who = '🎗 مالک گروه'
  elseif tonumber(result.from.id) == tonumber(our_id) then
    who = '🎗 سازنده گروه'
  else
    who = '👤 ممبر'
  end
  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
      who = '⭐️ مدیر کل ربات (سودو)'
    end
  end
 local text = '› نام کامل : '..(result.from.first_name or '')..' '..(result.from.last_name or '')..'\n'
             ..'› نام : '..(result.from.first_name or '')..'\n'
             ..'› نام خانوادگی : '..(result.from.last_name or '')..'\n'
             ..'› نام کاربری : '..user_name..'\n'
             ..'› کد کاربری : '..result.from.id..'\n'
             ..msgs..'\n'
             ..'› مقام : '..who..'\n\n'
             ..'› کد گروه : '..msg.to.id..'\nِ'
              
  send_large_msg(extra.receiver, text)
end

local function run(msg, matches)
   if matches[1] == 'info' and msg.reply_id then
     get_message(msg.reply_id, action_by_reply, {receiver=get_receiver(msg)})
   end
end

return {
    patterns = {
      "^([Ii]nfo)$",
      "^[!/](info)$"
    },
  run = run
}
end
