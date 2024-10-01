Param(
    [Parameter(Mandatory=$true)]
    [string]$query
)

Add-Type -AssemblyName System.Web

$configFilePath = "./scraper.ini"

$config = Get-Content -Path $configFilePath | Out-String | ConvertFrom-StringData

$maxScrapeRows = [int]$config.MAX_SCRAPE_ROWS
$scrapeRows = [int]$config.SCRAPE_ROWS
$scrapeDaysDelta = [int]$config.SCRAPE_DAYS_DELTA
$apiFqdn = [string]$config.API_FQDN

Write-Host $apiFqdn

$scrapeEndDate = (Get-Date).AddDays(-1)
$scrapeStartDate = $scrapeEndDate.AddDays(-$scrapeDaysDelta)

$scrapeDatesRange = $scrapeStartDate.ToString("yyyy-MM-dd") + "/" + $scrapeEndDate.ToString("yyyy-MM-dd")

# URLの作成
$nvCollection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
$nvCollection.Add("Query", $query)
$nvCollection.Add("CFT_Issue_Date", $scrapeDatesRange)
$nvCollection.Add("Count", $scrapeRows)

$uriRequest = [System.UriBuilder]::new($apiFqdn)
$uriRequest.Query = $nvCollection.ToString()
$requestUri = $uriRequest.Uri.OriginalString

Write-Host "API URL: $($requestUri)"

# GETリクエストの発行
$response = Invoke-RestMethod -Uri $requestUri -Method Get

# XML型へ変換
$responseXML = [xml]$response

# 検索結果数を取得
$searchHits = [int]$responseXml.Results.SearchResults.SearchHits

# 検索結果数を表示
Write-Host "検索結果件数: $searchHits"

# 検索結果数を評価

if ($searchHits -gt $scrapeRows) {
    Write-Host "全ての案件が取得できません。取得件数か取得期間を調整してください。"

    if ($searchHits -gt $maxScrapeRows) {
        Write-Host "現在設定可能な取得件数より多いので、取得期間を調整する必要があります。"
    }
}
else {
    Write-Host "全ての案件が正常に取得されました。"
}

# 案件要素を抽出

$items = $responseXml.Results.SearchResults.SearchResult
$selectedItems = $items | Select-Object @{Name="項番"; Expression={[int]$_.ResultId}}, @{Name="告示日"; Expression={[DateTime]::Parse($_.CftIssueDate)}}, @{Name="キー"; Expression={$_.Key.'#cdata-section'}}, @{Name="自治体名"; Expression={$_.PrefectureName}}, @{Name="組織名"; Expression={$_.OrganizationName}}, @{Name="案件名"; Expression={$_.ProjectName}}

$selectedItems | Export-Csv -Path "exported.csv"
