# Agent Preview Output Size Budget

## 목적

Agent 설정 preview가 상시 context를 과도하게 점유하지 않도록 line, heading과 estimated token 기준을 제공한다. Fragment 전문과 skill 본문을 무분별하게 삽입하는 것을 방지하고, 길이 초과 시 필수 규칙을 자르지 않고 구조적으로 분리하게 하는 정책이다.

이 기준은 MVP의 수동 검토용 정량 정책이다. 실제 tokenizer, line counter와 validator는 구현하지 않는다.

## 측정 단위

- Line count: 빈 줄을 포함한 Markdown 전체 line 수
- Heading count: `#`으로 시작하는 Markdown heading 수
- Estimated token: 실제 target model tokenizer가 없을 때 사용하는 수동 추정값
- Skill body inline: `SKILL.md` 절차 본문을 project instruction에 직접 복사했는지 여부

수동 estimated token은 한국어·영문 혼합 Markdown에서 대략 `문자 수 ÷ 3`을 보수적 참고값으로 사용한다. 실제 구현 단계에서는 target adapter/model tokenizer 또는 검증된 추정기로 교체해야 하며 이 값을 billing이나 hard compatibility 보장으로 사용하지 않는다.

## Output Type별 Budget

| Output type | 목표 budget | Warning 기준 | Error 기준 |
| --- | --- | --- | --- |
| Project instruction preview | 300 lines, 24 headings, 4,000 estimated tokens 이하 | 목표 중 하나 초과 | 450 lines, 36 headings 또는 6,000 tokens 초과 |
| Included fragment summary | 80 lines, 12 headings, 1,000 estimated tokens 이하 | 목표 중 하나 초과 | 140 lines 또는 1,800 tokens 초과 |
| Included skill summary | 50 lines, 8 headings, 700 estimated tokens 이하 | 목표 중 하나 초과 | 90 lines, 12 headings 또는 1,200 tokens 초과 |
| Warning/report section | 120 lines, 16 headings, 1,400 estimated tokens 이하 | 목표 중 하나 초과 | 200 lines, 24 headings 또는 2,400 tokens 초과 |

Project instruction budget은 adapter별 `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` preview 본문 전체에 적용한다. Summary/report 하위 budget은 전체 preview와 별도로 검토해 특정 section이 context를 독점하지 않게 한다.

## Severity 기준

### Info

- 모든 target budget 안에 있다.
- Deduplication으로 제거된 source와 lazy-loaded skill을 기록한다.
- Token 값이 수동 추정임을 표시한다.

### Warning

- Output type의 목표 line, heading 또는 estimated token 중 하나를 초과했지만 error 기준 이하다.
- 정량값을 계산할 수 없거나 source가 동적으로 달라 수동 검토가 필요하다.
- 필수 내용은 유지하되 요약·분리 후보와 영향 범위를 report에 기록한다.

### Error

- Output type의 error line, heading 또는 estimated token 기준 중 하나를 초과한다.
- Skill body를 project instruction preview에 직접 inline한다.
- 길이를 맞추기 위해 필수 보안·검증·scope 규칙을 임의 절단해야 한다.
- 미치환 placeholder 또는 source 추적 불가 내용 때문에 크기 결과를 신뢰할 수 없다.

Error가 있으면 완성 preview 상태를 `blocked`로 처리한다. Warning만 있으면 근거와 manual review 조건을 포함해 `ready-with-warnings`가 가능하다.

## Skill Body Inline 금지

- Preview에는 skill ID, trigger, 역할과 참조 위치만 둔다.
- 작업 절차, checklist와 상세 예시는 해당 skill을 실제로 선택한 시점에 lazy load한다.
- Profile에 포함됐다는 이유만으로 모든 `SKILL.md` 본문을 합치지 않는다.
- Adapter가 별도 skill 구조를 지원하지 않아도 본문 전체를 상시 지침으로 자동 확장하지 않는다.
- Inline이 불가피하다고 판단되면 generator가 아니라 adapter capability 및 profile 정책을 수동 재검토한다.

## 초과 시 처리 정책

1. 같은 대상·조건·동작의 fragment 규칙을 하나로 요약하고 provenance는 유지한다.
2. 일반 원칙은 core에 한 번만 두고 stack·bridge에는 구체적인 차이만 남긴다.
3. Skill은 링크/참조와 짧은 trigger만 유지하고 본문을 제거한다.
4. 긴 배경, 비교표와 예시는 `docs/` 또는 별도 report로 분리한다.
5. Warning/report의 반복 source와 동일 root cause를 묶는다.
6. 목표 budget을 계속 초과하면 manual review를 요구한다.
7. Error 기준을 초과하면 preview를 차단하고 필수 규칙을 임의 절단하지 않는다.

## Adapter 적용 기준

- Codex `AGENTS.md`, Claude `CLAUDE.md`, Gemini `GEMINI.md` project preview에 같은 기본 budget을 적용한다.
- Agent별 context와 skill 지원 차이가 확인되면 adapter-specific budget을 별도 metadata로 추가할 수 있다.
- Adapter-specific 기준은 기본 보안·scope 규칙을 약화할 수 없다.
- 현재 adapter는 모두 draft이므로 기본 budget만 사용하고 차이는 unsupported feature로 보고한다.

## Profile 표현 기준

이 정량 정책을 적용하는 Profile `output.size_budget`은 최소한 다음 값을 제공한다.

- Policy document: `docs/output-size-budget.md`
- Project preview `max_lines`
- Project preview `max_headings`
- Project preview `max_estimated_tokens`
- Error threshold는 이 문서의 공통 기준을 따른다는 선언

Profile이 더 엄격한 값을 지정할 수 있지만 공통 error 기준보다 느슨하게 만들려면 별도 근거와 manual review가 필요하다.

## Manual 검토 기록

- Output type과 측정 대상 파일
- Line, heading, 문자 수와 estimated token
- 적용 severity와 초과한 기준
- 요약·분리한 source와 보존한 provenance
- Reviewer 결정과 남은 adapter-specific 위험

## 현재 범위

이 정책은 설계상 숫자와 판정 기준만 정의한다. Tokenizer, counter, validator, 자동 요약과 file writer는 구현하지 않는다.
