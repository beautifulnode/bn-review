request = require 'request'
memeGenerator = 'http://version1.api.memegenerator.net/Instance_Create'
imageUri = 'http://images.memegenerator.net/instances'
[username, password, languageCode] = ['jackhq', 'foobar63', 'en']
instanceCreate = (generatorID, imageID, text0, text1, cb) ->
  request memeGenerator, 
    form: { username, password, languageCode, generatorID, imageID, text0, text1 }
    (e, r, b) ->
      result = JSON.parse(b)['result']
      if result? and result['instanceUrl']? and result['instanceImageUrl']? and result['instanceID']?
        instanceID = result['instanceID']
        instanceURL = result['instanceUrl']
        request instanceURL, (err, res, body) ->
          cb null, "#{imageUri}/#{instanceID}.jpg"

match = (input, exp) ->
  res = input.match(exp)
  [ res?[1] or null, res?[2] or null]

memes = [
  { phrase: /(Y U NO) (.+)/i, generateID: 2, imageID: 166088 }
  { phrase: /(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)/i, generateID: 74, imageID: 2485 }
  { phrase: /(.*)(O\s?RLY\??.*)/i, generateID: 920, imageID: 117049 }
  { phrase: /(.*)(SUCCESS|NAILED IT.*)/i, generateID: 121, imageID: 1031 }
  { phrase: /(.*) (ALL the .*)/i, generateID: 6013, imageID: 1121885 }
  { phrase: /(.*) (\w+\sTOO DAMN .*)/i, generateID: 998, imageID: 203665 }
  { phrase: /(GOOD NEWS EVERYONE[,.!]?) (.*)/i, generateID: 1591, imageID: 112464 }
  { phrase: /(NOT SURE IF .*) (OR .*)/i, generateID: 305, imageID: 84688 }
  { phrase: /(YO DAWG .*) (SO .*)/i, generateID: 79, imageID: 108785 }
]

module.exports = (input, cb) ->
  # read meme phrase and generate meme image 
  # from phrase
  selectedMeme = null
  for meme in memes
    [text, text2] = match input, meme.phrase
    if text? and text2?
      selectedMeme = meme
      break
  instanceCreate selectedMeme.generateID, selectedMeme.imageID, text, text2, cb