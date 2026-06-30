# Compatibility Pending 항목

## 목적

`registry/compatibility-matrix.yml`의 pending relation을 지원 완료와 구분하고, 보류 이유와 재검토 조건을 기록한다. 이 문서는 registry 상태를 변경하거나 존재하지 않는 bridge를 가정하지 않는다.

## `spring-msa`

- 관계: `framework-spring`과 `architecture-msa`
- Pending 이유: Spring bean·transaction·application lifecycle과 독립 service의 배포, 장애 격리, 통신 실패 및 데이터 소유권을 연결하는 책임이 정의되지 않았다.
- Bridge 필요성: 단순 동시 선택만으로 bridge를 확정하지 않는다. Spring lifecycle이 service 경계와 실패 의미에 실제 제약을 만들 때 별도 bridge 책임을 검토한다.
- 처리 방향: 현재 profile과 MVP 대상에 MSA가 없으므로 보류한다. MSA profile 또는 Spring 기반 MSA 대표 조합을 추가할 때 적용 조건과 검증 기준부터 설계한다.
- 현재 MVP 영향: 기존 6개 profile과 Codex dry-run에는 영향이 없다. 향후 입력이 이 relation을 선택하면 supported로 추정하지 않고 pending 진단 대상으로 남긴다.

## `restful-api-msa`

- 관계: `api-restful-api`와 `architecture-msa`
- Pending 이유: Service별 API 소유권, contract versioning, service 간 호출 실패와 외부 계약 경계를 연결하는 책임이 정의되지 않았다.
- Bridge 필요성: REST 원칙과 MSA 원칙의 단순 병합으로 의미가 충분한지, 별도 bridge가 필요한지는 대표 조합 검토 후 결정한다.
- 처리 방향: 현재 MVP profile이 MSA를 선택하지 않으므로 보류한다. MSA profile과 consumer/provider 경계가 구체화될 때 bridge 또는 compatible 관계를 선택한다.
- 현재 MVP 영향: 기존 preview와 dry-run readiness에는 영향이 없다. 선택 입력에 포함되면 지원 완료로 처리하지 않고 pending 사유와 수동 결정 필요성을 보고한다.

## 재검토 진입 조건

- MSA profile 또는 대표 dry-run이 범위에 포함된다.
- Source/target의 교차 책임이 독립 fragment만으로 해결되지 않는 근거가 확인된다.
- Bridge의 적용 조건, dependency, conflict와 validation 기준을 작성할 수 있다.
- Current generator validation policy가 pending relation의 warning 또는 blocking 기준을 확정한다.

조건이 충족되기 전에는 두 relation과 registry YAML을 그대로 유지한다.
