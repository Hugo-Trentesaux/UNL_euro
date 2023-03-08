using CSV, Plots, DataFrames, Dates, Colors

TIME_INTERVAL = (Date(1997), Date(2023,03))
TIME_TICKS = Date.(1997:2:2023)
TIME_TICKS_STR = string.(Dates.year.(TIME_TICKS))

EURO_TICKS = [5e6, 1e7, 1.5e7]
EURO_TICKS_STR = ["5000 milliards d'€", "10 000 milliards d'€", "15 000 milliards d'€"]

GROWTH_TICKS = -2:14
GROWTH_TICKS_STR = string.(GROWTH_TICKS) .* " %"

MONTH_CONV = Dict(
    "Jan" => 1,
    "Feb" => 2,
    "Mar" => 3,
    "Apr" => 4,
    "May" => 5,
    "Jun" => 6,
    "Jul" => 7,
    "Aug" => 8,
    "Sep" => 9,
    "Oct" => 10,
    "Nov" => 11,
    "Dec" => 12,
)

keys = [
    "BSI.M.U2.Y.V.M10.X.1.U2.2300.Z01.E",
    "BSI.M.U2.Y.V.M20.X.1.U2.2300.Z01.E",
    "BSI.M.U2.Y.V.M30.X.1.U2.2300.Z01.E",
    "BSI.M.U2.Y.V.M30.X.I.U2.2300.Z01.A",
    ]

c1 = CSV.read("data/$(keys[1]).csv", DataFrame, header=false, skipto=7)
c2 = CSV.read("data/$(keys[2]).csv", DataFrame, header=false, skipto=7)
c3 = CSV.read("data/$(keys[3]).csv", DataFrame, header=false, skipto=7)
c4 = CSV.read("data/$(keys[4]).csv", DataFrame, header=false, skipto=7)

"converts YYYYMmm format to Date"
to_date(date::AbstractString) = Date(parse(Int, date[1:4]), MONTH_CONV[date[5:7]])

# dates
d1 = to_date.(c1[:,1])
d2 = to_date.(c2[:,1])
d3 = to_date.(c3[:,1])
d4 = to_date.(c4[:,1])

# million euro
M1 = c1[:,2]
M2 = c2[:,2]
M3 = c3[:,2]
M3v = c4[:,2]

plot(
    size=(1400,720), legend=:topleft, thickness_scaling=1.3,
    xticks = (TIME_TICKS, TIME_TICKS_STR),
    yticks = (EURO_TICKS, EURO_TICKS_STR),
    left_margin=-20Plots.px, right_margin=80Plots.px, 
)
xlims!(TIME_INTERVAL)
ylims!((0, 1.6e7))
# xlabel!("date")
# ylabel!("€")
plot!(d3, M3, fillrange=0, color=colorant"#FDD221", label="M3")
plot!(d2, M2, fillrange=0, color=colorant"#FF4013", label="M2")
plot!(d1, M1, fillrange=0, color=colorant"#010080", label="M1")

plot!(twinx(), d4, M3v, color=colorant"#5B9024", linewidth=3, label="M3 variation",
legend=:bottomright,
xticks=false, ylims=(-2, 14), ylabel="croissance annuelle",
yticks= (GROWTH_TICKS, GROWTH_TICKS_STR))
xlims!(TIME_INTERVAL)

savefig("M1M2M3euro.png")
savefig("M1M2M3euro.svg")