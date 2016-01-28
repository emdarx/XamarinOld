do

function run(msg, matches)
  return " The Support Invition Link : \n https://telegram.me/joinchat/ClGL-QOZQ4RTxMp6nzU3YA"
  end
return {
  description = "shows support link", 
  usage = "!tosupport : Return supports link",
  patterns = {
    "^tosupport$",
    "^/tosupport$",
    "^!tosupport$",
    "^>tosupport$",
  },
  run = run
}
end
