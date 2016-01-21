do

function run(msg, matches)
  return "تو زاده کیر مصنوعی ای " .. matches[1]
end

return {
    patterns = {
    "^فحش بده به (.*)$"
  }, 
  run = run 
}

end
