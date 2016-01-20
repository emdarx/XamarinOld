do
 function run(msg, matches)
 
  local fuse = '📌 #فیدبک جدید\n\n👤 نام کاربری : @' .. msg.from.username .. '\n\n👤 نام کاربر : ' .. msg.from.print_name ..'\n\n👤 یوزر آی دی : ' .. msg.from.id .. '\n\n📝 متن پیام : \n' .. matches[1] 
 local fuses = '!printf user#id' .. msg.from.id
 
   local text = matches[1]
   local chat = "chat#id"..90312082 
   --like : local chat = "chat#id"..12345678
   
  local sends = send_msg(chat, fuse, ok_cb, false)
  return '✅ Message successfully sent'
 
 end
 end
 return {
  
  description = "Feedback",
 
  usage = "!feedback message",
  patterns = {
  "^[!/][Ff]eedback (.*)$"
 
  },
  run = run
 }
