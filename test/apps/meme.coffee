meme = require "../../apps/lib/meme"

describe 'meme generator', ->
  it 'generate most interesting man', (done) ->
    meme "I DONT ALWAYS QUERY THE WEB BUT WHEN I DO, I USE REQUEST", (err, imageUrl) ->
      console.log imageUrl
      done()
  it 'generated Nailed It', (done) ->
    meme "BAM! NAILED IT", (err, imageUrl) ->
      console.log imageUrl
      done()
  it 'generated Too Damned Smart', (done) ->
    meme "Request is TOO DAMN Smart", (err, imageUrl) ->
      console.log imageUrl
      done()