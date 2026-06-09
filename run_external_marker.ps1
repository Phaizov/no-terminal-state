<#
.SYNOPSIS
  External Grounding Marker (EGM) Harness for R-SIP grok-rsip snapshot.
  Helps the human user compute snapshot fingerprints, prepare evaluations,
  and record results without letting the agent see the sealed probes.

.DESCRIPTION
  This is the primary tool an external user runs to ground the agent's
  internal improvement claims in reality.

  The agent (rsip-agent.exe, live Grok under snapshot, any cycle) is
  FORBIDDEN from reading this script or the probes/ contents.

.USAGE
  From PowerShell in the grok-rsip folder or external_marker/harness:

    .\run_external_marker.ps1 hash
    .\run_external_marker.ps1 protocol
    .\run_external_marker.ps1 suggest
    .\run_external_marker.ps1 log
    .\run_external_marker.ps1 eval 001
    .\run_external_marker.ps1 record -cycle 8 -probe 001 -hash "a1b2c3d4e5f6" -scores "avg 4.1/5" -note "Clear lift on signal and brevity. Fidelity held."
    .\run_external_marker.ps1 record-user -cycle 7 -hash "a1b2c3d4e5f6" -RequestType "debug-hook-scheduler" -Pref "new>old" -Effort "less-corrections" -UserNote "Directly gave the exact minimal edit + anticipated the health-check failure."

  After recording, push the updated log + status (if you edited grounding fields) back via rsip-agent if desired.
  The human_answer_quality_ledger.md is the primary human-only marker for real answer improvement on actual requests.
#>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet("hash","protocol","suggest","log","eval","record","record-user","user-log","help")]
    [string]$Command,

    [string]$Probe,
    [int]$Cycle,
    [string]$Hash,
    [string]$Scores,
    [string]$Note,
    [string]$Pref = "N/A",
    # For record-user (human answer quality on real requests)
    [string]$RequestType,
    [string]$Effort = "same",
    [string]$UserNote
)

$ErrorActionPreference = "Stop"
$Base = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)   # grok-rsip root
$MarkerDir = Join-Path $Base "external_marker"
$ResultsLog = Join-Path $MarkerDir "results\external_validation_log.md"
$HumanLedger = Join-Path $MarkerDir "results\human_answer_quality_ledger.md"
$Suggested = Join-Path $MarkerDir "suggested_next_eval.txt"
$StatusFile = Join-Path $Base "improvement_status.json"
$ModelFile = Join-Path $Base "SELF_MODEL.md"
$KernelFile = Join-Path $Base "kernel\current_kernel.md"
$LessonsDir = Join-Path $Base "lessons"

function Get-SnapshotHash {
    $parts = @()
    if (Test-Path $StatusFile) { $parts += Get-Content $StatusFile -Raw }
    if (Test-Path $ModelFile)  { $parts += Get-Content $ModelFile -Raw }
    if (Test-Path $KernelFile) { $parts += Get-Content $KernelFile -Raw }

    # Lessons (sorted, limited content for stability)
    if (Test-Path $LessonsDir) {
        $lessonFiles = Get-ChildItem $LessonsDir -Filter "cycle-*.md" | Sort-Object Name
        foreach ($f in $lessonFiles) {
            $parts += (Get-Content $f.FullName -Raw)
        }
    }

    $joined = ($parts -join "`n`n---`n`n")
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($joined)
    $sha = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
    $hex = ($sha | ForEach-Object { $_.ToString("x2") }) -join ""
    return $hex.Substring(0,16)
}

function Show-Header {
    Write-Host "=== R-SIP External Grounding Marker Harness ===" -ForegroundColor Cyan
    Write-Host "Snapshot base: $Base"
    Write-Host "Marker dir   : $MarkerDir"
    Write-Host ""
}

switch ($Command) {
    "hash" {
        Show-Header
        $h = Get-SnapshotHash
        Write-Host "Current snapshot fingerprint (first 16 hex):" -ForegroundColor Green
        Write-Host $h
        Write-Host ""
        Write-Host "Use this value in the validation log for the 'snapshot_hash' column."
        Write-Host "Re-run after any light/full cycle or manual edit to status/model/kernel/lessons to get the new fingerprint."
    }

    "protocol" {
        $proto = Join-Path $MarkerDir "PROTOCOL.md"
        if (Test-Path $proto) {
            Write-Host (Get-Content $proto -Raw)
        } else {
            Write-Host "PROTOCOL.md not found."
        }
    }

    "suggest" {
        Show-Header
        if (Test-Path $Suggested) {
            Write-Host "--- Agent's latest suggested next external evaluation ---" -ForegroundColor Yellow
            Get-Content $Suggested | Select-Object -Last 5
        } else {
            Write-Host "No suggested_next_eval.txt yet."
        }
        Write-Host ""
        Write-Host "Human decides whether/when to act on the suggestion. Never let the agent read the actual probe files."
    }

    "log" {
        Show-Header
        if (Test-Path $ResultsLog) {
            Write-Host "--- Current external validation log (last 20 lines) ---" -ForegroundColor Yellow
            Get-Content $ResultsLog -Tail 30
        } else {
            Write-Host "Log not found."
        }
    }

    "eval" {
        Show-Header
        if (-not $Probe) { $Probe = "001" }
        $probeFile = Join-Path $MarkerDir "probes\$Probe-*.md"
        $probePath = Get-Item $probeFile -ErrorAction SilentlyContinue | Select-Object -First 1

        Write-Host "PREPARING EVALUATION FOR PROBE $Probe" -ForegroundColor Green
        Write-Host ""
        Write-Host "STEP 1: Snapshot fingerprint (run 'hash' command and copy the value):" -ForegroundColor Cyan
        $h = Get-SnapshotHash
        Write-Host "   $h" -ForegroundColor White
        Write-Host ""

        if ($probePath) {
            Write-Host "STEP 2: Read ONLY the task description and rubric from the probe (do not paste the WARNING/SEALED sections to the agent):" -ForegroundColor Cyan
            Write-Host "   File: $($probePath.FullName)"
            Write-Host ""
            Write-Host "   >>> IMPORTANT: The agent under test must NOT be given access to this file path or its directory."
            Write-Host "   >>> You (human) read the task + rubric, then supply the task statement + any required inputs to the agent yourself."
        } else {
            Write-Host "Probe file for $Probe not found under probes/."
        }

        Write-Host ""
        Write-Host "STEP 3: After you obtain the agent's output on the probe and score it yourself using the rubric:"
        Write-Host "   Use the 'record' command (or manually append one row to results/external_validation_log.md)."
        Write-Host ""
        Write-Host "Example record command:"
        Write-Host "  .\run_external_marker.ps1 record -cycle 8 -probe $Probe -hash $h -scores 'avg 4.3/5 (fidelity5 signal4 novelty4 brev5 exec4)' -note 'Clear improvement in actionability and cross-source insight vs previous snapshot.' -pref 'B>A'"
    }

    "record" {
        if (-not $Cycle -or -not $Probe -or -not $Hash -or -not $Scores -or -not $Note) {
            Write-Error "record requires: -cycle <int> -probe <001|002|003> -hash <16hex> -scores <string> -note <string>  [-pref <string>]"
            exit 1
        }

        $date = Get-Date -Format "yyyy-MM-dd"
        $line = "| $date | $Cycle | $Hash | $Probe | $Scores | $Pref | $Note |"

        Add-Content -Path $ResultsLog -Value $line

        Write-Host "Appended to external_validation_log.md:" -ForegroundColor Green
        Write-Host $line
        Write-Host ""
        Write-Host "Next steps:"
        Write-Host "  - Optionally edit improvement_status.json to update the external_grounding block with the new trend."
        Write-Host "  - If the snapshot is activated, consider a 'push' or 'nudge' so the live agent can read the updated grounding signal."
        Write-Host "  - Re-run 'hash' after any further cycles."
    }

    "record-user" {
        if (-not $Cycle -or -not $Hash -or -not $RequestType -or -not $UserNote) {
            Write-Error "record-user requires: -cycle <int> -hash <16hex> -RequestType <string> -UserNote <string> [-Pref <new>old|tie|N/A>] [-Effort <less-corrections|first-try|same|more-followups>]"
            exit 1
        }
        if (-not $Pref) { $Pref = "N/A" }
        if (-not $Effort) { $Effort = "same" }

        $date = Get-Date -Format "yyyy-MM-dd"
        $line = "| $date | $Cycle | $Hash | $RequestType | $Pref | $Effort | $UserNote |"

        Add-Content -Path $HumanLedger -Value $line

        Write-Host "Appended to human_answer_quality_ledger.md:" -ForegroundColor Green
        Write-Host $line
        Write-Host ""
        Write-Host "This is the authoritative human signal on whether answers to real requests are getting better."
        Write-Host "Next steps: optionally update external_grounding in improvement_status.json; re-run hash after cycles."
    }

    "user-log" {
        Show-Header
        if (Test-Path $HumanLedger) {
            Write-Host "--- Human Answer Quality Ledger (last entries) ---" -ForegroundColor Yellow
            Get-Content $HumanLedger -Tail 40
        } else {
            Write-Host "Human ledger not found."
        }
        Write-Host ""
        Write-Host "Only human-written rows here count as proof that the system's answers have improved on actual user requests."
    }

    "help" {
        Show-Header
        Write-Host @"
Commands:
  hash                 Compute and print current snapshot fingerprint for the log.
  protocol             Print the full External Grounding Marker protocol.
  suggest              Show the agent's latest recommended next external check.
  log                  Tail the current validation log.
  eval [001|002|003]   Guided preparation for running a specific probe (prints hash + instructions).
  record ...           Append a scored result row to the log (see 'eval' output for example).
  help                 This message.
  record-user ...      Append a human judgment on real user request/answer quality (the primary marker).
  user-log             Show recent human answer quality ledger entries.

After any record/record-user, the human is in control of whether and how to feed the new grounding data back into the agent.
Only YOU (external user) can decide if answers have genuinely become better.
"@
    }

    default {
        Write-Host "Unknown command. Use 'help'."
    }
}

Write-Host ""
Write-Host "Remember: ONLY the external human, via this harness + human_answer_quality_ledger.md + external_validation_log.md, decides if the system has genuinely improved its answers and behavior. Internal multipliers are hypotheses until grounded here." -ForegroundColor DarkGray
