using Pkg
using JSON3
using DataFrames
using CSV


link = "https://services-eu1.arcgis.com/zk7YlClTgerl62BY/ArcGIS/rest/services/wojewodztwa_corona_widok/FeatureServer/0/query?f=json&where=2%3D2&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=jpt_nazwa_%20asc&resultOffsetsc&resultOffset=0&resultRecordCount=380&resultType=standard&cacheHint=tru"
download(link, "dane_woj.json")
data = JSON3.read(read("dane_woj.json", String))
df = [DataFrame(data["features"][i]["attributes"]) for i in 1:length(data["features"])]


CSV.write("MZ/mz_covid19_woj_.csv", df; delim=';')


df2 = CSV.File("MZ/mz_covid19_woj_.csv") |> DataFrame  

df2 .= replace.(df2, r"\]"=>"") 
df2 .= replace.(df2, r"\["=>"") 
df2 .= replace.(df2, r"\""=>"") 

CSV.write("MZ/mz_covid19_woj_.csv", df2; delim=';')