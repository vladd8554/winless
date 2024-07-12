local http = require 'nix/http'
local json = require 'nix/json'

local RichEmbed = { data = {} }
local Discord = {}

function Discord.new(URL)
    return setmetatable({ URL = URL }, { __index = Discord })
end

function Discord:setUsername(username) self.username = username end
function Discord:setAvatarUrl(url) self.avatar_url = url end

function RichEmbed.new(data)
    return setmetatable({ data = data }, { __index = RichEmbed })
end

function Discord:send(...)
    local body = {}
    local arguments = { ... }

    if self.username then body.username = self.username end
    if self.avatar_url then body.avatar_url = self.avatar_url end
    
    for _, value in next, arguments do
        if type(value) == 'table' then
            if not body.embeds then
                body.embeds = {}
            end

            table.insert(body.embeds, value.data)
        elseif type(value) == 'string' then
            body.content = value
        end
    end
    
    http.post(self.URL, {
        headers = {
            ['Content-Type'] = 'application/json',
            ['Content-Length'] = #json.stringify(body)
        },
        body = json.stringify(body),
    }, function (status, response) end)
end

function RichEmbed:setTitle(title)
    self.data.title = title
end

function RichEmbed:setDescription(str)
    self.data.description = str
end

function RichEmbed:setColor(color)
    self.data.color = color
end

return {
    Webhook = Discord,
    RichEmbed = RichEmbed
}
