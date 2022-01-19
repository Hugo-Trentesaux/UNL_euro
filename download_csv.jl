using HTTP

keys = [
    "BSI.M.U2.Y.V.M10.X.1.U2.2300.Z01.E",
    "BSI.M.U2.Y.V.M20.X.1.U2.2300.Z01.E",
    "BSI.M.U2.Y.V.M30.X.1.U2.2300.Z01.E",
    "BSI.M.U2.Y.V.M30.X.I.U2.2300.Z01.A",
    ]

url(key) = "https://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=$(key)&type=csv"

mkpath("data")

for key in keys
    r = HTTP.get(url(key))
    open(joinpath("data", "$(key).csv"), "w") do io
        write(io, r.body)
    end
end

