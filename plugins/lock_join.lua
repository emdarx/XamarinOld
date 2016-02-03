if msg.action and msg.action.type then

    local action = msg.action.type

    if action == 'chat_add_user_link' then

      local user_id = msg.from.id

    if data[tostring(msg.to.id)]['settings']['lock_join'] == 'yes' then

  if not is_momod(msg) then

  chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)

    local msg = 'Join link is Locked !'

   local receiver = msg.to.id

    send_large_msg('chat#id'..receiver, msg.."\n", ok_cb, false)

  

      end

   end

end

return {

   description = "to lock joining by link",

   usage = "!lock join : no one can come to group by link",

   patterns = {

      "^!!tgservice (chat_add_user_link)$",

},

   run = run

}
