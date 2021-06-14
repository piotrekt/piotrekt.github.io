using Pkg
using JSON3
using DataFrames
using CSV


link ="https://services-eu1.arcgis.com/zk7YlClTgerl62BY/ArcGIS/rest/services/powiaty_corona_widok_woj/FeatureServer/0/query?f=json&where=2%3D2&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=JPT_KJ_I_2%20asc&resultOffsetsc&resultOffset=0&resultRecordCount=380&resultType=standard&cacheHint=true"

download(link, "dane.json")
data = JSON3.read(read("dane.json", String))
df = [DataFrame(data["features"][i]["attributes"]) for i in 1:length(data["features"])]


CSV.write("MZ/mz_covid19_powiaty_.csv", df; delim=';')


df2 = CSV.File("MZ/mz_covid19_powiaty_.csv") |> DataFrame  

select!(df2, Not(:JPT_KJ_I_1))   
select!(df2, Not(:OBJECTID)) 
select!(df2, Not(:POTWIERDZONE_10_TYS_OSOB)) 
select!(df2, Not(:LICZBA_OZDROWIENCOW)) 
select!(df2, Not(:Shape__Area_2)) 
select!(df2, Not(:Shape__Length_2)) 
select!(df2, Not(:Shape__Length)) 
select!(df2, Not(:Shape__Area)) 

df2 .= replace.(df2, r"\]"=>"") 
df2 .= replace.(df2, r"\["=>"") 
df2 .= replace.(df2, r"\""=>"") 

CSV.write("MZ/mz_covid19_powiaty_.csv", df2; delim=';')
