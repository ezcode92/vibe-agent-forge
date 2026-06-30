# Generator 구현 전 결정사항

## 목적

Phase 8의 설계 문서와 manual dry-run에서 확인된 미결정 항목을 실제 구현 전에 검토할 decision backlog로 관리한다. 이 문서는 결론, 구현 승인 또는 code/API 계약을 확정하지 않는다.

## 결정 기록 원칙

각 항목은 현재 사실, 선택 후보, 평가 기준, 영향 자산과 승인 근거를 기록한 뒤 확정한다. 한 항목의 선택이 registry, profile, adapter 또는 output 계약을 바꾸면 관련 문서를 같은 변경에서 갱신한다.

## 결정 필요 항목

### 1. Generator 실행 형태

- 결정 질문: Preview 조합 기능을 어떤 사용자·도구 경계에서 호출할 것인가.
- 평가 기준: 재현성, 입력 전달, 오류 보고, 로컬 권한, agent 독립성과 test 가능성.
- 현재 상태: 문서 기반 수동 dry-run만 존재하며 실행 형태는 선택하지 않았다.

### 2. Validator 범위와 Schema Validation

- 결정 질문: YAML 구조, ID/path, dependency, compatibility, variant, semantic conflict와 output budget 중 어디까지 자동 검증할 것인가.
- 함께 결정할 사항: Profile path 참조를 catalog ID로 전환하는 시점과 schema 형식·version·migration 책임.
- 평가 기준: 잘못된 입력의 조기 차단, schema와 의미 검증의 책임 분리, 기존 draft 자산 호환성.
- 현재 상태: YAML parse와 참조 무결성은 수동 검사한다.

### 3. Merge, Deduplication과 결정적 결과

- 결정 질문: Semantic rule 추출·중복 판단 단위와 동일 입력의 deterministic serialization 범위를 어디까지 보장할 것인가.
- 평가 기준: Provenance 보존, 의미 손실 방지, 안정적인 비교, adapter별 표현 차이.
- 현재 상태: Manual merge trace와 사람이 수행하는 의미 중복 제거만 존재한다.

### 4. Adapter Capability와 Validation Policy

- 결정 질문: Adapter capability version, output size 보정, pending/unregistered 관계의 허용 정책을 어디에서 관리할 것인가.
- 평가 기준: Agent별 기능 차이, catalog 책임, 조직별 정책, warning과 blocking의 일관성.
- 현재 상태: Codex는 `mvp-contract`, Claude/Gemini는 `draft`이며 공통 수동 budget을 사용한다.

### 5. Project Binding 방식

- 결정 질문: Project 목적, stack, 명령, scope와 repository metadata를 preview 입력에 어떤 방식으로 연결할 것인가.
- 평가 기준: Existing file 무변경, secret·local 설정 분리, source provenance와 재현성.
- 현재 상태: Dry-run은 project metadata placeholder를 사용하며 실제 repository binding은 없다.

### 6. Output Write 허용 시점과 Dry-run/Export 경계

- 결정 질문: Preview-only 상태에서 실제 write를 언제 별도 capability로 승인하고 어떤 보호·검토 조건을 요구할 것인가.
- 평가 기준: 명시적 사용자 승인, 대상 path, overwrite·backup·rollback, protected file, write 결과 보고.
- Dry-run: `writePerformed: false`이며 review용 논리 결과만 만든다.
- 실제 export: Filesystem side effect와 적용 책임이 생기므로 별도 설계·승인 전에는 지원하지 않는다.

## 완료 조건

- 각 항목의 선택과 근거가 관련 계약 문서에 반영된다.
- 결정 사이의 충돌과 migration 영향이 검토된다.
- Codex 대표 profile로 선택 결과를 다시 수동 검증한다.
- 구현 범위와 제외 범위가 별도 승인을 받을 정도로 명확해진다.
