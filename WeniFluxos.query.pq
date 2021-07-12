// Use this file to write queries to test your data connector
// pass your org token to first param of WeniFluxos.Contents to test
let
    after = DateTime.FromText("2021/01/01"),
    before = DateTime.FromText("2021/06/27"),
    result = WeniFluxos.Contents("", after, before)
//     flows = result{[Name="flows"]}[Data]
in
    result
//     flows