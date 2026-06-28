---
name: security-review
description: 변경이나 설계의 secret, 입력 검증, 인증·인가, injection, 파일·경로·명령 실행과 민감정보 로그 위험을 증거 중심으로 검토한다. 외부 입력 또는 권한·데이터 경계에 영향을 주는 변경을 security 관점에서 review할 때 사용한다.
---

# Security Review

## 목적

신뢰 경계와 공격 가능한 입력 흐름을 따라 실제 보안 위험을 식별하고 최소한의 대응 방향을 제시한다. 수정까지 요청되지 않았다면 finding을 보고하고 코드를 변경하지 않는다.

## 사용 조건

- Review 대상과 신뢰 경계를 먼저 정한다.
- 인증·인가, 민감정보, 외부 입력 또는 실행 권한에 영향이 있는 변경을 우선한다.
- 확인할 수 없는 위협은 가정과 필요한 증거를 분리한다.

## 입력 Context

- 변경 diff, 데이터 흐름과 외부 entry point
- 인증 주체, 권한 model과 resource 소유 관계
- 입력 validation, query, file I/O와 command 실행 경로
- Secret 관리, log·오류와 저장·전송 정책

## 작업 절차

1. 보호할 자산, 신뢰 경계, 공격자 입력과 권한을 식별한다.
2. Source, 설정, history와 산출물에 secret 또는 credential이 노출되는지 확인한다.
3. 외부 입력의 형식, 길이, 허용값과 canonicalization이 사용 전에 검증되는지 추적한다.
4. 인증과 인가를 구분하고 모든 resource 접근이 server-side 권한 검사를 거치는지 확인한다.
5. SQL/query, template, shell과 interpreter 경계의 injection 가능성과 parameterization을 검토한다.
6. File path의 기준 경로, traversal, symlink와 읽기·쓰기 권한을 검토한다.
7. Command 실행의 allowlist, 인자 분리, 권한과 destructive 영향 범위를 확인한다.
8. Log와 error에 secret, token, 개인정보와 내부 구현 정보가 포함되지 않는지 확인한다.
9. Finding별 공격 조건, 영향, 근거와 최소 대응을 심각도 순으로 정리한다.

## 검증 기준

- 각 finding은 신뢰 경계, 입력 경로와 영향을 재현 가능하게 설명한다.
- 인증 성공이 resource 인가를 대신하지 않는다.
- 입력이 위험한 sink에 도달하기 전에 검증·escaping·parameterization된다.
- Secret과 민감정보가 code, Git, log와 오류 response에 노출되지 않는다.
- False positive 가능성과 환경 의존 가정이 명시된다.

## 금지 패턴

- 실제 입력 경로 없이 일반 보안 체크리스트만 나열하지 않는다.
- Client-side validation을 권한 또는 보안 검증으로 간주하지 않는다.
- Secret 값을 출력, 복사, 저장하거나 검증 목적으로 commit하지 않는다.
- 문자열 결합 command/query와 검증되지 않은 path를 안전하다고 가정하지 않는다.
- 수정 요청 없이 광범위한 보안 구조 변경을 수행하지 않는다.

## 완료 기준

- 위험이 심각도, 공격 조건, 영향과 근거를 포함해 정리된다.
- Secret, 입력, 인증·인가, injection, 파일·명령과 log 경계를 모두 검토한다.
- 즉시 차단할 문제와 방어 심화 제안을 구분한다.
- 검증하지 못한 환경과 남은 위험을 보고한다.

## 참고 문서

- `docs/skill-spec.md`
- `core/global/agents.fragment.md`
- 프로젝트의 보안·개인정보·권한 정책
