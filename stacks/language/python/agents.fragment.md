# Python Language Fragment

## 목적

Python 코드의 명시성, typing, 데이터 모델, 경로와 예외 처리에 공통으로 적용할 언어 수준의 판단 기준을 정의한다. Web, CLI, database framework와 배포 도구의 구체 규칙은 다루지 않는다.

## 적용 대상

- Stack 식별자: `language-python`
- 적용 조건: Python module과 package를 작성, 수정 또는 검토하는 프로젝트
- 제외 조건: 특정 framework의 request lifecycle, command 구조 또는 persistence 규칙

## 핵심 규칙

- 축약보다 의도가 드러나는 이름과 직접적인 제어 흐름을 선택하고 숨은 전역 상태와 import 부작용을 피한다.
- Public 함수, 경계 객체와 복잡한 내부 로직에는 type hint를 제공한다. Type hint는 실제 runtime 동작과 일치시킨다.
- `dataclass`는 데이터와 값 의미가 중심인 타입에 사용하고, 복잡한 불변식이나 resource lifecycle을 단순 field 묶음으로 축소하지 않는다.
- File path는 문자열 조작 대신 `pathlib.Path`로 표현하고, 외부 입력 경로의 기준 위치와 허용 범위를 검증한다.
- Exception은 구체적인 타입을 필요한 범위에서만 처리하고 원인 chain을 보존한다. 복구할 수 없는 실패를 빈 값으로 숨기지 않는다.
- 표준 library와 기존 dependency로 충분하면 새 dependency를 추가하지 않으며, 추가 시 유지보수성·보안·배포 비용을 설명한다.
- 핵심 로직은 I/O, 환경 변수, 시간과 외부 service에서 분리해 pytest에서 결정적으로 검증 가능한 구조로 둔다.

## 권장 패턴

- Module의 공개 책임을 좁히고 import 방향과 package 경계를 명시적으로 유지한다.
- Mutable 기본 인자를 피하고 값이 없음을 의미하는 sentinel과 실제 값의 의미를 구분한다.
- Context manager로 file, lock과 연결 같은 resource의 획득·해제를 한 경계에서 관리한다.
- 작은 순수 함수와 dependency 주입 가능한 경계를 사용해 test fixture와 대역의 범위를 최소화한다.

## 금지 패턴

- 동적 특성을 이유로 타입과 입력 계약을 문서화하지 않거나 무분별한 `Any`로 type 검사를 우회하지 않는다.
- `except Exception` 또는 bare `except`로 오류를 삼키거나 정상 제어 흐름을 exception에 의존하지 않는다.
- 경로를 문자열 연결로 만들거나 검증되지 않은 외부 경로를 그대로 읽고 쓰지 않는다.
- 편의를 위한 단일 함수 때문에 대형 dependency를 추가하지 않는다.
- Test가 import 순서, 실제 network, system clock 또는 사용자 환경에 암묵적으로 의존하게 하지 않는다.

## 검증 기준

- Public 계약과 주요 데이터 구조의 type hint가 runtime 동작 및 지원 Python 버전과 일치한다.
- `dataclass` 사용 대상이 값 중심이고 mutable field의 소유권과 기본값이 안전하다.
- 경로 처리와 resource 정리가 명시적이며 exception 원인과 실패 의미가 보존된다.
- 새 dependency가 최소이며 필요성과 대체 가능성을 검토했다.
- 관련 pytest, type checker, lint가 프로젝트 설정에 따라 통과하거나 미실행 사유가 보고된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Python typing, packaging 또는 test 전용 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Python type, exception, async 또는 resource 경계를 framework/platform의 실행 모델과 연결해야 할 때 bridge가 필요하다.
- Framework route, command 선언과 lifecycle 규칙은 이 fragment에 추가하지 않는다.
