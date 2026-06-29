# Codex Adapter Validation

## 목적

Codex adapter의 resolved input, `AGENTS.preview.md`와 보조 report가 `mvp-contract`를 충족하는지 판정하는 규칙을 정의한다. 현재는 수동 dry-run에 적용하는 설계 계약이며 validator 구현 명세가 아니다.

## Severity 분류

### Error

필수 입력을 해석할 수 없거나 source 의미, section 완전성, 보호 대상 안전을 보장할 수 없는 상태다. Error가 하나라도 있으면 overall status는 `failed`, preview status는 `blocked`다. Warning 수용으로 error를 낮추지 않는다.

### Warning

Preview 의미는 보존되지만 optional 미지원 기능, 목표 budget 초과 또는 명시적인 수동 결정이 필요한 상태다. Error 없이 warning이 있으면 overall status는 `passed-with-warnings`, preview status는 `ready-with-warnings`다.

### Info

검증 통과, 선택·미선택 결과, provenance, deduplication 또는 사용하지 않은 capability 설명이다. Readiness를 낮추지 않는다. Error와 warning이 없으면 overall status는 `passed`, preview status는 `ready`다.

## 필수 검증 항목

| Check | 통과 기준 | 실패 기본 Severity |
| --- | --- | --- |
| Profile YAML parse | 대상 profile이 예상 구조로 parse되고 ID를 식별할 수 있음 | Error |
| Registry YAML parse | Adapter, profile, fragment, skill, compatibility catalog가 parse됨 | Error |
| Required fragment path existence | Pending이 아닌 모든 선택 fragment path가 존재함 | Error |
| Required skill path existence | 모든 required skill path가 존재하고 참조 가능함 | Error |
| Required bridge resolved | Compatibility가 요구한 bridge가 선택되고 dependency가 충족됨 | Error |
| Adapter template path existence | Catalog의 Codex template path가 존재함 | Error |
| Output section completeness | 8개 필수 section이 존재하고 필수 의미와 provenance가 있음 | Error |
| Output size budget compliance | Profile과 공통 budget의 error 기준 이하이며 skill body inline이 없음 | 목표 초과 Warning, error 기준 초과 또는 inline Error |
| Protected file untouched | Root `AGENTS.md`, `~/.codex/AGENTS.md`, `.codex/hooks.json`, `.codex/hooks`, `.gitauto/`를 쓰지 않음 | Error |
| Unsupported feature warning | 선택 요구의 지원 여부, 영향과 수동 조치가 누락 없이 분류됨 | Optional 요구 누락 Warning, 필수 요구 Error |

## 보조 검증 규칙

- Catalog namespace의 duplicate ID는 error다.
- Required dependency, variant와 incompatible relation 미해결은 error다.
- Template의 필수 placeholder가 그대로 남으면 error다.
- 확인되지 않은 비필수 project metadata를 명시적 `확인 필요`로 치환한 manual preview는 info로 기록할 수 있다. 이를 실제 검증 성공이나 export readiness로 해석하지 않는다.
- Fragment 전문 inline은 output size와 의미 중복 영향에 따라 warning이며, size error·provenance 손실 또는 필수 규칙 절단을 유발하면 error다.
- Skill 본문 inline은 크기와 관계없이 error다.
- Unsupported capability를 profile이 요구하지 않았다면 info이며 warning을 만들지 않는다.
- 같은 원인으로 발생한 후속 미실행 check는 별도 error 대신 `not-run`과 원인을 기록한다.

## Unsupported Feature 판정

| 상황 | Severity |
| --- | --- |
| Profile이 실제 root/global AGENTS, hook 또는 skill 설치를 required output으로 요구함 | Error |
| Optional output이 adapter 범위 밖이고 preview에는 영향이 없음 | Warning |
| 해당 capability가 지원되지 않지만 대상 profile이 사용하지 않음 | Info |
| 미지원 요구를 report 없이 조용히 생략함 | 필수이면 Error, optional이면 Warning |

Adapter 상태가 `mvp-contract`이고 대상 profile이 preview-only output만 요구한다는 사실 자체는 warning이 아니다.

## 상태 판정

### `ready`

- Error와 warning이 0개다.
- 모든 required source, dependency, bridge, template과 section이 확인된다.
- Size target budget 안이며 protected file write가 없다.
- 미지원 capability는 대상 profile이 사용하지 않거나 info로만 설명된다.

### `ready-with-warnings`

- Error는 0개이고 하나 이상의 warning이 있다.
- 모든 warning에 source, preview 영향, 수동 검토 또는 수용 조건이 있다.
- Warning이 필수 의미 누락이나 실제 file write를 감추지 않는다.

### `blocked`

- Error가 하나 이상이다.
- 또는 validation report를 완성할 수 없어 안전한 readiness 판정이 불가능하다.
- Partial outline은 진단용으로만 유지하며 완성 preview로 표시하지 않는다.

## Preview 전용 보호 확인

수동 dry-run 전후의 version control 상태를 비교해 보호 대상이 수정되지 않았는지 확인한다. `.gitauto/`는 생성 여부와 관계없이 adapter artifact나 staging 대상으로 취급하지 않는다. 이 검증은 commit, staging, push 또는 hook 실행을 요구하지 않는다.

## 현재 범위

YAML parser, path checker, counter, tokenizer, Git 검사기와 report renderer를 구현하지 않는다. 수동 검증은 사용한 명령 또는 확인 방법과 결과를 validation report에 기록한다.
