---
name: ui-error-handling
description: Frontend UI 오류를 사용자 행동 가능성에 따라 분류하고 표시 message, 내부 진단, retry와 loading·empty·error 상태를 일관되게 설계한다. 화면의 실패 UX를 추가·검토할 때 사용한다.
---

# UI Error Handling

## 목적

사용자가 실패를 이해하고 가능한 다음 행동을 선택할 수 있게 하면서 내부 진단 정보와 민감정보를 안전하게 분리한다. 특정 notification component나 logging 제품의 API는 다루지 않는다.

## 사용 조건

- Async 작업, 입력, 권한 또는 예기치 않은 실패가 UI에 노출될 때 적용한다.
- 오류의 source와 복구 가능성을 확인한다.
- Error 표시만으로 해결할 수 없는 데이터 손상·보안 문제는 해당 경계로 escalation한다.

## 입력 Context

- 사용자 작업, 화면 상태와 실패 유형
- API/client error taxonomy와 retry 정책
- Logging·추적 식별자 및 개인정보 정책
- 접근성, focus, announcement와 localization 요구

## 작업 절차

1. Validation, authentication, permission, network, conflict와 unexpected error를 사용자 행동 기준으로 분류한다.
2. Retry 가능 오류, 입력 수정 필요 오류와 사용자 해결 불가 오류를 구분한다.
3. 사용자 message에는 상황과 다음 행동만 제공하고 내부 원인·stack·민감정보는 제외한다.
4. 내부 log에는 필요한 context와 추적 식별자를 남기되 credential과 개인정보를 제거한다.
5. Loading, empty, partial, stale와 error 상태의 우선순위 및 전환을 정의한다.
6. Error 위치, focus 이동, screen reader announcement와 retry control의 접근성을 검토한다.
7. 중복 제출, retry 성공·실패와 navigation 후 stale error를 포함해 검증한다.

## 검증 기준

- 사용자는 오류 원인 범주와 가능한 다음 행동을 이해할 수 있다.
- 사용자 message와 내부 log의 정보 수준이 분리된다.
- Retry가 가능한 경우에만 제공되고 중복 side effect를 만들지 않는다.
- Loading, empty, partial과 error 상태가 동시에 모순되게 표시되지 않는다.
- Keyboard·screen reader·focus 흐름에서 오류를 인지하고 복구할 수 있다.

## 금지 패턴

- 내부 exception, endpoint, stack trace와 credential을 사용자 message에 노출하지 않는다.
- 모든 실패를 동일 toast나 일반 문구로 처리하지 않는다.
- 실패 원인을 숨기기 위해 empty state로 대체하지 않는다.
- 접근할 수 없는 색상만으로 오류를 표시하거나 focus를 잃게 하지 않는다.

## 완료 기준

- 오류 taxonomy, 사용자 message와 복구 action이 정의된다.
- 내부 log와 민감정보 경계가 명확하다.
- Async 상태와 접근성 검증이 통과한다.
- 미지원 복구와 운영 관측의 남은 이슈가 보고된다.

## 참고 문서

- `skills/common/security-review/SKILL.md`
- `skills/frontend/api-client-integration/SKILL.md`
- 프로젝트의 접근성·logging·오류 정책
