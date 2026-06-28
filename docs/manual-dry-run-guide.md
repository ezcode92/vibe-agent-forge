# Manual Dry-run 가이드

## 목적

Manual dry-run은 generator 구현 없이 profile, registry, fragment, skill, adapter와 template이 하나의 preview 계약으로 연결되는지 사람이 검증하는 절차다. Source 누락과 설계 충돌을 코드 구조로 고정하기 전에 발견하는 것이 목적이다.

## Generator 구현 전에 수행하는 이유

- Catalog ID와 profile path 참조가 아직 혼재한다.
- Semantic deduplication, conflict와 output length 기준이 확정되지 않았다.
- Adapter가 설계 초안이며 실제 capability 검증이 남아 있다.
- Pending compatibility와 존재하지 않는 bridge가 있다.
- 수동 trace를 통해 generator가 반드시 보고해야 할 provenance와 warning을 구체화할 수 있다.

Dry-run은 구현을 대체하지 않지만 구현 범위를 증거 없이 넓히는 것을 방지한다.

## 대상 선택 기준

- 실제 profile manifest와 catalog entry가 존재한다.
- 필요한 fragment와 skill source가 모두 존재한다.
- Target adapter 문서와 template이 존재한다.
- 최소 하나의 bridge 또는 compatibility 관계를 포함해 검증 가치가 있다.
- Pending과 unsupported가 있어도 이유와 preview 영향이 설명 가능하다.
- 기존 project 파일에 write하지 않고 example 문서로 결과를 남길 수 있다.

첫 대상은 backend 조합, bridge와 skill category가 충분히 포함된 `backend-kotlin-spring-rdb` + Codex다.

## Dry-run 입력

- Selected profile ID와 manifest
- Target adapter ID, contract와 template
- Registry catalog 5종
- Profile이 참조하는 fragment와 skill
- Merge, skill selection, output과 validation report 설계 문서
- 실제 project metadata가 없으면 placeholder와 warning 정책

## 산출물 구조

```text
examples/<adapter>/<profile>/
├── README.md
├── AGENTS.preview.md 또는 agent별 preview 문서
├── merge-trace.md
├── skill-selection.md
└── validation-report.md
```

위 구조 표시는 문서 위치 설명이며 generator나 scaffold script가 아니다.

### README

대상, 목적, source, preview 제한과 실제 적용 전 검토 항목을 기록한다.

### Preview

Adapter template section을 따르되 fragment 전문과 모든 skill 본문을 복사하지 않는다. 실제 설정과 혼동되지 않게 title과 안내에 dry-run/preview/example을 명시한다.

### Merge Trace

선택 fragment, category, priority, dependency, compatibility, deduplication과 conflict 후보를 기록한다.

### Skill Selection

Profile skill, common/stack-specific 역할, routing과 lazy loading 기준을 기록한다.

### Validation Report

Phase 8 check별 severity, status, source, warning과 preview readiness를 기록한다.

## 수행 순서

1. Git 상태와 보호 대상 파일을 확인한다.
2. Profile, catalog, adapter와 template을 parse·대조한다.
3. Fragment 및 skill path와 dependency를 확인한다.
4. Compatibility, required bridge, pending과 conflict를 확인한다.
5. Section 순서와 authority priority를 구분해 merge trace를 작성한다.
6. Skill routing과 lazy loading을 정리한다.
7. Placeholder를 유지한 압축 preview를 작성한다.
8. Validation report와 readiness를 판정한다.
9. Root agent 파일, catalog/profile/template와 hook이 변경되지 않았는지 확인한다.

## 결과에 따른 Generator 범위 조정

| Dry-run 관찰 | Generator 설계 조정 후보 |
| --- | --- |
| Profile path와 catalog ID mapping 반복 | 명시적 resolver와 mismatch check 필요 |
| 같은 규칙의 반복 | Rule provenance와 deduplication 결과 필요 |
| Pending relation 발견 | Warning 및 사용자 수용 상태 필요 |
| Skill 본문 과다 | Metadata discovery와 lazy loading 분리 필요 |
| Adapter unsupported | Output별 capability와 blocking 정책 필요 |
| 비정량 size budget | Token/length policy 결정 필요 |

Dry-run에서 발견한 문제를 즉시 generator code로 해결하지 않는다. 설계 문서와 catalog 책임 중 어디를 조정할지 먼저 결정하고 별도 구현 승인을 받는다.

## 다음 Dry-run 후보

### `python-cli-automation` + Codex

- Architecture fragment pending 표현
- Bridge 없는 단순 profile
- Automation 및 Git-auto skill routing 검증

### `frontend-react` + Codex

- JavaScript–React bridge
- REST API client와 backend 미지정 관계
- UI skill lazy loading 검증

### `flutter-app` + Codex

- Dart–Flutter 및 Flutter–REST API bridge
- Mobile offline/auth/version skill 구분
- Build/debug skill과 project command placeholder 검증

## 금지 범위

- 실제 agent 설정과 global 파일 생성
- Existing file overwrite, backup와 export
- Generator, validator와 CLI 구현
- Registry/profile/template 자동 수정
- Git commit·push와 hook 변경

## 현재 범위

현재 manual dry-run은 문서 기반 검증이다. Example은 source-of-truth가 아니며 원본 profile, catalog, fragment, skill과 adapter를 대체하지 않는다.
