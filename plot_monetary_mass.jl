using CSV, Plots, DataFrames, Dates, Colors

TIME_INTERVAL = (Date(1999), Date(2023,03))
TIME_TICKS = Date.(1999:2:2023)
TIME_TICKS_STR = string.(Dates.year.(TIME_TICKS))


Y_LIMS = (0, 1.8e7)
EURO_TICKS = [1.5e6, 5e6, 1e7, 1.5e7]
EURO_TICKS_STR = ["1500 Md€", "5000 Md€", "10 000 Md€", "15 000 Md€"]

YY_LIMS = (-3, 15)
GROWTH_TICKS = -1:13
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
    "ILM.M.U2.C.LT00001.Z5.EUR",
    "BKN.M.U2.NC10.B.ALLD.AS.S.E",
    "BKN.M.U2.NC10.C.ALLD.AS.S.E",
    ]

c1 = CSV.read("data/$(keys[1]).csv", DataFrame, header=false, skipto=7)
c2 = CSV.read("data/$(keys[2]).csv", DataFrame, header=false, skipto=7)
c3 = CSV.read("data/$(keys[3]).csv", DataFrame, header=false, skipto=7)
c4 = CSV.read("data/$(keys[4]).csv", DataFrame, header=false, skipto=7)
c5 = CSV.read("data/$(keys[5]).csv", DataFrame, header=false, skipto=7)
c6 = CSV.read("data/$(keys[6]).csv", DataFrame, header=false, skipto=7)
c7 = CSV.read("data/$(keys[7]).csv", DataFrame, header=false, skipto=7)

"converts YYYYMmm format to Date"
to_date(date::AbstractString) = Date(parse(Int, date[1:4]), MONTH_CONV[date[5:7]])

# dates
d1 = to_date.(c1[:,1])
d2 = to_date.(c2[:,1])
d3 = to_date.(c3[:,1])
d4 = to_date.(c4[:,1])
d5 = to_date.(c5[:,1])
d6 = to_date.(c6[:,1])
d7 = to_date.(c7[:,1])

# million euro
M0 = c5[:,2]
M1 = c1[:,2]
M2 = c2[:,2]
M3 = c3[:,2]
M3v = c4[:,2]
# thousands euro
B = c6[:,2]/1000
C = c7[:,2]/1000

plot(
    size=(1400,720), legend=:topleft, thickness_scaling=1.3,
    xticks = (TIME_TICKS, TIME_TICKS_STR),
    yticks = (EURO_TICKS, EURO_TICKS_STR),
    left_margin=-20Plots.px, right_margin=80Plots.px, 
)
xlims!(TIME_INTERVAL)
ylims!(Y_LIMS)

plot!(d3, M3, fillrange=0, color=colorant"#FDD221", label="M3")
plot!(d2, M2, fillrange=0, color=colorant"#FF4013", label="M2")
plot!(d1, M1, fillrange=0, color=colorant"#010080", label="M1")
plot!(d5, M0, color=colorant"#CCC", label="M0", linewidth=2)
plot!(d6, B+C, color=colorant"#88F", label="billets et pièces", linewidth=2)

plot!(twinx(), d4, M3v, color=colorant"#5B9024", linewidth=3, label="M3 variation",
legend=false,
xticks=false, ylabel="M3 variation annuelle", xlims=TIME_INTERVAL,
yticks=(GROWTH_TICKS, GROWTH_TICKS_STR), ylims=YY_LIMS, y_foreground_color_text=colorant"#5B9024")


savefig("M1M2M3euro.png")
savefig("M1M2M3euro.svg")