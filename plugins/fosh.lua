-- https://github.com/amirhmz/
-- https://telegram.me/AmirDark/
do

function run(msg, matches)
  return "تو زاده کیر مصنوعی ای " .. matches[1]
end

return {
    patterns = {
    "^فحش بده به (.*)$",
    "^[Ff]osh [Bb]ede [Bb]e (.*)$",
  }, 
  run = run 
}

end
-- https://github.com/amirhmz/
-- https://telegram.me/AmirDark/
