using CSV, Plots, DataFrames, Dates, Colors

TIME_INTERVAL = (Date(1999), Date(2024,03))
TIME_TICKS = Date.(1999:2:2024)
TIME_TICKS_STR = string.(Dates.year.(TIME_TICKS))


Y_LIMS = (0, 1.8e10)
EURO_TICKS = [1.5e9, 5e9, 1e10, 1.5e10]
EURO_TICKS_STR = ["1500 Md€", "5000 Md€", "10 000 Md€", "15 000 Md€"]

YY_LIMS = (-3, 15)
GROWTH_TICKS = -1:13
GROWTH_TICKS_STR = string.(GROWTH_TICKS) .* " %"

keys = [
    "BSI.M.U2.Y.V.M10.X.1.U2.2300.Z01.E", # M1
    "BSI.M.U2.Y.V.M20.X.1.U2.2300.Z01.E", # M2
    "BSI.M.U2.Y.V.M30.X.1.U2.2300.Z01.E", # M3
    "BSI.M.U2.Y.V.M30.X.I.U2.2300.Z01.A", # M3 variation
    "ILM.M.U2.C.LT00001.Z5.EUR", # M0
    "BKN.M.U2.NC10.B.ALLD.AS.S.E", # Billets
    "BKN.M.U2.NC10.C.ALLD.AS.S.E", # Pièces
    ]

# read csv
c = CSV.read("data/BSI.M.U2.Y.V.M_star.csv", DataFrame, missingstring="NA")
ilm = CSV.read("data/$(keys[5]).csv", DataFrame)
bkn_b = CSV.read("data/$(keys[6]).csv", DataFrame)
bkn_c = CSV.read("data/$(keys[7]).csv", DataFrame)

# sort by date
sort!(c, :"Obs. Date")
# reinterpret string values
r(x) = if ismissing(x) return x else parse(Float64, replace(x, ","=>"")) end
c.var"Obs. value" .= r.(c.var"Obs. value")

"filter by key"
cx(x) = c[c.var"Series key" .== keys[x], :]

"get date"
dx(x) = cx(x).var"Obs. Date"

"get value (billions)"
vx(x) = cx(x).var"Obs. value" * 1e6
"get value (no scaling)"
vpx(x) = cx(x).var"Obs. value"

plot(
    size=(1400,720), legend=:topleft, thickness_scaling=1.3,
    xticks = (TIME_TICKS, TIME_TICKS_STR),
    yticks = (EURO_TICKS, EURO_TICKS_STR),
    left_margin=-20Plots.px,
    framestyle=:box, 
)
xlims!(TIME_INTERVAL)
ylims!(Y_LIMS)

# Manually add grid lines for the main plot becuase there is a bug
# https://stackoverflow.com/questions/77988830/how-to-display-grid-for-main-axis-and-not-for-twinx
for ytick in EURO_TICKS
    hline!([ytick], color=:black, alpha=0.2, lw=0.5, label=false)
end

# masse monétaire (milliers → euros)
ilm_v = ilm.var"Base money (ILM.M.U2.C.LT00001.Z5.EUR)" * 1e3
# pièces et billets (€)
b_plus_c = 
    bkn_b.var"Net Circulation - number of banknotes/coins in circulation in Euro Area (BKN.M.U2.NC10.B.ALLD.AS.S.E)" +
    bkn_c.var"Net Circulation - number of banknotes/coins in circulation in Euro Area (BKN.M.U2.NC10.C.ALLD.AS.S.E)"

plot!(dx(3), vx(3), fillrange=0, color=colorant"#FDD221", label="M3")
plot!(dx(2), vx(2), fillrange=0, color=colorant"#FF4013", label="M2")
plot!(dx(1), vx(1), fillrange=0, color=colorant"#010080", label="M1")
plot!(ilm.DATE, ilm_v, color=colorant"#CCC", label="M0", linewidth=2)
plot!(bkn_c.DATE, b_plus_c, color=colorant"#88F", label="billets et pièces", linewidth=2)


plot!(twinx(), dx(4), vpx(4), color=colorant"#5B9024", linewidth=3, label="M3 variation",
    legend=false,
    xticks=false, ylabel="M3 variation annuelle", xlims=TIME_INTERVAL,
    yticks=(GROWTH_TICKS, GROWTH_TICKS_STR), ylims=YY_LIMS, y_foreground_color_text=colorant"#5B9024",
    grid=false)

savefig("M1M2M3euro.png")
savefig("M1M2M3euro.svg")