# API Documentation

Phneak Teb uses the **VirusTotal API v3** to analyse URLs.

## Authentication

All requests send the API key in the `x-apikey` header:

```
x-apikey: <YOUR_VIRUSTOTAL_API_KEY>
```

Configure the key in `lib/config/api_keys.dart` or via:

```bash
flutter run --dart-define=VT_API_KEY=your_real_key
```

## Endpoints used

### 1. Get a URL report

```
GET https://www.virustotal.com/api/v3/urls/{id}
```

- `{id}` is the **base64url** encoding of the URL (no padding).
- Returns `last_analysis_stats` (malicious / suspicious / harmless / undetected)
  and `last_analysis_results` (per-engine verdicts).

**Example response (trimmed):**

```json
{
  "data": {
    "attributes": {
      "last_analysis_stats": {
        "malicious": 2,
        "suspicious": 1,
        "harmless": 70,
        "undetected": 5,
        "timeout": 0
      }
    }
  }
}
```

### 2. Submit a URL for analysis

```
POST https://www.virustotal.com/api/v3/urls
Content-Type: application/x-www-form-urlencoded

url=https://example.com
```

Used automatically when a URL has not been analysed yet (HTTP 404 on the GET).

## Verdict mapping

| Condition                              | Verdict      |
|----------------------------------------|--------------|
| `malicious >= 3`                       | Malicious    |
| `malicious >= 1` or `suspicious >= 1`  | Suspicious   |
| otherwise                              | Safe         |

Thresholds live in `lib/config/constants.dart`.

## Rate limits

The free VirusTotal tier is limited (e.g. 4 requests/min). The smart blocklist
reduces API calls by caching previously-flagged domains locally.
