[Version = "1.0.0"]
section RapidPro;

RapidPro.RootEntities = {
    "broadcasts.json",
    "channel_stats.json",
    "contacts.json",
    "flows.json",
    "flow_starts.json",
    "messages.json",
    "runs.json"
};

DefaultBaseURL = "https://rapidpro.ilhasoft.mobi";

shared RapidPro.ConnectionTest = () =>
    let
        source = Web.Contents(DefaultBaseURL),
        res = Xml.Document(source)
    in
        res;

[DataSource.Kind="RapidPro", Publish="RapidPro.Publish"]
shared RapidPro.Contents = (url as text, token as text, optional after as datetime, optional before as datetime) => CCNavTable(url, token, after, before) as table;

RapidPro.GetData = (url as text, token as text, after as nullable datetime, before as nullable datetime) as table => GetAllPagesByNextLink(url, token, after, before);

CCNavTable = (url as text, token as text, after as nullable datetime, before as nullable datetime) as table =>
    let
        entitiesAsTable = Table.FromList(RapidPro.RootEntities, Splitter.SplitByNothing()),
        rename = Table.RenameColumns(entitiesAsTable, {{"Column1", "Endpoint"}}),
        withEntity = Table.AddColumn(rename, "Name", each Text.BeforeDelimiter([Endpoint],".")),
        withData = Table.AddColumn(withEntity, "Data", each RapidPro.GetData(Uri.Combine(url, [Endpoint]), token, after, before), Uri.Type),
        withItemKind = Table.AddColumn(withData, "ItemKind", each "Table", type text),
        withItemName = Table.AddColumn(withItemKind, "ItemName", each "Table", type text),
        withIsLeaf = Table.AddColumn(withItemName, "IsLeaf", each true, type logical),
        withoutEndpoint = Table.RemoveColumns(withIsLeaf, "Endpoint"),
        navTable = Table.ToNavigationTable(withoutEndpoint, {"Name"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
        navTable;

Table.ToNavigationTable = (
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = itemNameColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
        navigationTable;

Table.GenerateByPage = (getNextPage as function) as table =>
    let
        listOfPages = List.Generate(
            () => getNextPage(null),     
            (lastPage) => lastPage <> null,
            (lastPage) => getNextPage(lastPage)
        ),
        tableOfPages = Table.FromList(listOfPages, Splitter.SplitByNothing(), {"Column1"}),
        firstRow = tableOfPages{0}?
    in
        if (firstRow = null) then
            Table.FromRows({})
        else        
            Value.ReplaceType(
                Table.ExpandTableColumn(tableOfPages, "Column1", Table.ColumnNames(firstRow[Column1])),
                Value.Type(firstRow[Column1])
            );

GetAllPagesByNextLink = (url as text, token as text, after as nullable datetime, before as nullable datetime) as table =>
    Table.GenerateByPage((previous) => 
        let
            nextLink = if (previous = null) then url else Value.Metadata(previous)[NextLink]?,
            afterParam = if (previous = null) then after else null,  //prevent duplicate param in next link
            beforeParam = if (previous = null) then before else null,//\\ same
            page = if (nextLink <> null) then GetPage(nextLink, token, afterParam, beforeParam) else null
        in
            page
    );

GetPage = (url as text, token as text, after as nullable datetime, before as nullable datetime) as table =>
    let
        options = [
            Headers = [
                #"Accept" = "application/json",
                #"Authorization" = "Token " & token
            ]
        ],
        afterQ = if (after = null) then [] else [after = DateTime.ToText(after, "yyyy-MM-ddThh:mm:ss")],
        beforeQ = if (before = null) then [] else [before = DateTime.ToText(before, "yyyy-MM-ddThh:mm:ss")],
        query = Record.Combine({afterQ, beforeQ}),
        optionsWithQuery = Record.AddField(options, "Query", query), 
        response = Web.Contents(
            url, 
            optionsWithQuery
        ),
        body = Json.Document(response, 1252),
        nextLink = GetNextLink(body),
        data = Table.FromRecords(body[results])
    in
        data meta [NextLink = nextLink];

GetNextLink = (response) as nullable text => Record.FieldOrDefault(response, "next");

RapidPro = [
    TestConnection = (dataSourcePath) => { "RapidPro.ConnectionTest" },
    Authentication = [
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
RapidPro.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    SourceImage = RapidPro.Icons,
    SourceTypeImage = RapidPro.Icons
];

RapidPro.Icons = [
    Icon16 = { Extension.Contents("RapidPro16.png"), Extension.Contents("RapidPro20.png"), Extension.Contents("RapidPro24.png"), Extension.Contents("RapidPro32.png") },
    Icon32 = { Extension.Contents("RapidPro32.png"), Extension.Contents("RapidPro40.png"), Extension.Contents("RapidPro48.png"), Extension.Contents("RapidPro64.png") }
];
