# Database Relationship

This file contains a ER diagram, written with Markdown-inspired text definitions in mermaid syntax, for data models used in this custom connector.
It can be rendered in tools that support [mermaid](https://mermaid-js.github.io/mermaid).

```mermaid
erDiagram

channel {
    uuid string
    name string
    address string
    country string
    device string
    name string
    power_level int
    power_status string
    power_source string
    network_type string
    last_seen datetime
    created_on datetime
}

message {
    id int
    broadcast int
    contact string
    urn string
    channel string
    direction string
    type string
    status string
    visibility string
    text string
    attachments array
    labels array
    created_on datetime
    sent_on datetime
    modified_on datetime
}

contact {
    uuid string
    name string
    language string
    urns array
    groups array
    fields dictionary
    blocked boolean
    stopped boolean
    created_on datetime
    modified_on datetime
    last_seen_on datetime
}

flow {
    uuid string
    name string
    type string
    archived boolean
    labels array
    expires integer
    runs object
    results array
    parent_refs array
    created_on datetime
    modified_on datetime
}

run {
    uuid string
    flow string
    contact string
    start string
    responded boolean
    values array
    created_on datetime
    modified_on datetime
    exited_on datetime
    exit_type string
}

broadcast {
    id int
    urns string
    contacts array
    groups array
    text string
    status string
    created_on datetime
}

flowstart {
    uuid string
    flow object
    contacts array
    groups array
    restart_participants boolean
    exclude_active boolean
    status string
    params object
    created_on datetime
    modified_on datetime
}

broadcast |o--o{ message: relation

channel ||--o{ message: relation

contact ||--o{ message: relation

contact ||--o{ run: relation

flow ||--o{ run: relation

flowstart |o--o{ run: relation

channel ||--o{ broadcast: relation

flow ||--o{ flowstart: relation


```
