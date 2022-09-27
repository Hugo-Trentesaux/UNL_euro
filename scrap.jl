using Gumbo, HTTP

# look at https://sdw.ecb.europa.eu/reports.do?node=10000014

URL = "https://sdw.ecb.europa.eu/browse.do?node=bbn30"
HTML_FILE = "/home/hugo/Téléchargements/Data - 2 Money, banking and investment funds - Statistics Bulletin - ECB Statistical Data Warehouse.html"

open(HTML_FILE, "w") do io
    response = HTTP.get(URL)
    write(io, response.body)
end

doc = parsehtml(read(HTML_FILE, String))

# body of table
tbody = doc.root[2][2][2][1][3][2][1][1][1][9][2][45][5][2]

M_titles = Vector{String}()
M_keys = Vector{String}()

for tr in tbody.children
    title = tr[2][1][1].text
    key = strip(tr[3][1].text)
    push!(M_titles, title)
    push!(M_keys, key)
end

println("scrapped the following keys")
display([M_keys M_titles])