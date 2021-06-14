using Pkg
using JSON3
using DataFrames
using CSV


link ="https://services-eu1.arcgis.com/zk7YlClTgerl62BY/ArcGIS/rest/services/global_szczepienia_widok2/FeatureServer/0/query?f=json&where=2%3D2&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=OBJECTID%20asc&resultOffsetsc&resultOffset=0&resultRecordCount=380&resultType=standard&cacheHint=true%22"

download(link, "dane_szczepienia_global.json")
data = JSON3.read(read("dane_szczepienia_global.json", String))
df = [DataFrame(data["features"][i]["attributes"]) for i in 1:length(data["features"])]


CSV.write("MZ/mz_vacc_global_.csv", df; delim=';')


df2 = CSV.File("MZ/mz_vacc_global_.csv") |> DataFrame  

df2 .= replace.(df2, r"\]"=>"") 
df2 .= replace.(df2, r"\["=>"") 
df2 .= replace.(df2, r"\""=>"") 

CSV.write("MZ/mz_vacc_global_.csv", df2; delim=';')
