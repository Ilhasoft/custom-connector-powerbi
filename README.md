# Power BI Custom Connectors for Rapid Pro and Weni Fluxos

This repository intends to keep the Power BI Custom Connector for Weni Fluxos API and Rapid Pro.

## Quickstart
### Instalation

1. Download the .mez file of the desired connector from this repo.
2. Copy downloaded file to [Documents]/Power BI Desktop/Custom Connectors. 
 - (If you don't have these folders on your computer, you must create them)
3. Check the Allow any extensions to load without validation or warning in Power BI Desktop option under (File > Options > Security > Data Extensions).
4. Restart Power BI Desktop

### Getting Data

1. With Power BI Desktop open, look for the connector under Home > Get Data > Other.
2. Select the desired connector and Click “Connect” button.
3. A popup will appear to confirm if you want to connect to a third party service, confirm by clicking“Continue”.
4. Enter the token of the organization you want to get the data for, and optionally define the time period for which the data was created.
5. Select the items you want and click transform or load data.

## Additional links and resources
[M Library Functions](https://docs.microsoft.com/en-us/powerquery-m/power-query-m-function-reference)

[M Language Specification](https://docs.microsoft.com/en-us/powerquery-m/power-query-m-language-specification)

[Power BI Developer Center](https://powerbi.microsoft.com/developers/)

[Starting to Develop Custom Connectors](https://docs.microsoft.com/en-us/power-query/startingtodevelopcustomconnectors)
