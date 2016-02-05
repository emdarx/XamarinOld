 -- FeedBack Plugin For Xamarin Source v1.2
 --https://github.com/amirhmz
 --Telegram.me/AmirDark

do

 function run(msg, matches)
 local ch = 'chat#id'..msg.to.id
 local fuse = '📌 #فیدبک جدید\n\n👤 نام کاربر : ' .. msg.from.print_name ..'\n\n👤 نام کاربری : @' .. msg.from.username ..'\n\n👤 یوزر آی دی : ' .. msg.from.id ..'\n\n👤 گروپ آی دی :' ..msg.to.id.. '\n\n📝 متن پیام :\n\n' .. matches[1]
 local fuses = '!printf user#id' .. msg.from.id


   local text = matches[1]
   local chat = "chat#id"..83535263

  local sends = send_msg(chat, fuse, ok_cb, false)
  return 'Sent!'

 end
 end
 return {

  description = "Feedback",

  usage = "!feedback message",
  patterns = {
   "^[!/][Ff]eedback (.*)$"

  },
  run = run

 --https://github.com/amirhmz
 --Telegram.me/AmirDark
