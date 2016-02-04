local function run(msg)
if msg.text == "hi" then
	return "Hi Baby :)"
end
if msg.text == "Hi" then
	return "Hello Honey :)"
end
if msg.text == "Hello" then
	return "Hi :)"
end
if msg.text == "hello" then
	return "Hi Honey"
end
if msg.text == "Salam" then
	return "Salam Azizam"
end
if msg.text == "salam" then
	return "Salam"
end
if msg.text == "amir" then
	return "Ha?"
end
if msg.text == "Amir" then
	return "Koft Chikaresh Dari?"
end
if msg.text == "amin" then
	return "Rafte Lala :/"
end
if msg.text == "Amin" then
	return "Khabe :|"
end
if msg.text == "mamshotak" then
	return "Nagaiiidam!"
end
if msg.text == "Mamshotak" then
	return "چچچ نگاییدم"
end
if msg.text == "?" then
	return "Chiye?"
end
if msg.text == "Bye" then
	return "Bye Dayus"
end
if msg.text == "bye" then
	return "Bye"
end
if msg.text == "سلام زامارین" then
	return "سلام عزیزم :)"
end
if msg.text == "زامارین سلام" then
	return "سلام عزیزم :)"
end
if msg.text == "ممشوتک" then
	return "چچچ نگاییدم"
end
if msg.text == "امین" then
	return "رفته استخر :|"
end
if msg.text == "زامارین" then
	return "ها جیه؟"
end
if msg.text == "ایلیا" then
	return "با جیگرم چیکار داری؟"
end
if msg.text == "سپهر" then
	return "رفته توالت وایسا بیاد"
end
if msg.text == "امیر" then
	return "با باباییم چیکار داری؟ 😐"
end
if msg.text == "امیر دارک" then
	return "با باباییم چیکار داری؟ 😐"
end
end

return {
	description = "Chat With Robot Server", 
	usage = "chat with robot",
	patterns = {
    "^[Hh]i$",
	"^[Hh]ello$",
    "^[Ss]alam$",
    "^[Aa]mir$",
    "^[Aa]min$",
    "^[Mm]amshotak$",
    "^?$",
	"^[Bb]ye$",
	"^سلام زامارین",
  "^زامارین سلام",
	"^ممشوتک",	
	"^امین",	
	"^زامارین",
	"^ایلیا",
	"^سپهر",
	"^امیر",
	"^امیر دارک",
	
		}, 
	run = run,
    --privileged = true,
	pre_process = pre_process
}
