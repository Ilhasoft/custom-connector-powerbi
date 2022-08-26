// Use this file to write queries to test your data connector
// pass your org token to first param of WeniFluxos.Contents to test
let
    after = DateTime.FromText("2021/01/01"),
    before = DateTime.FromText("2022/07/01"),
    result = WeniFluxos.Contents("token", after, before),
    flows = result{[Name="flows"]}[Data]
in
    flows
