# Java Language Fragment

## 목적

Java 코드의 타입 설계, 객체 협력, 값 부재, 예외와 collection 처리에 공통으로 적용할 언어 수준의 판단 기준을 정의한다. Framework, database, 배포 구조와 제품별 library 사용법은 다루지 않는다.

## 적용 대상

- Stack 식별자: `language-java`
- 적용 조건: Java source를 작성, 수정 또는 검토하는 프로젝트
- 제외 조건: 다른 JVM 언어의 관례나 특정 framework의 lifecycle을 결정하는 작업

## 핵심 규칙

- Class는 하나의 변경 이유와 유효 상태를 소유하게 하고, field를 직접 노출하지 말고 불변식을 method 경계에서 보호한다.
- `null` 허용 여부를 API 경계에서 명확히 하며, 값 부재가 정상 결과인 반환에는 의미가 분명할 때 `Optional`을 사용한다. `Optional`을 field, parameter와 collection element에 일률적으로 사용하지 않는다.
- Exception은 복구 가능성과 호출자 계약을 기준으로 checked 또는 unchecked를 선택한다. 원인을 보존하고, 처리할 수 없는 exception을 기록만 한 뒤 무시하지 않는다.
- Collection은 가장 좁은 interface 타입으로 노출하고, 수정 가능 여부와 소유권을 명확히 한다. 외부에 반환한 내부 mutable collection으로 상태가 우회 변경되지 않게 한다.
- Stream은 변환 pipeline이 반복문보다 의도를 명확히 할 때 사용하며 중간 연산에 상태 변경이나 외부 부작용을 넣지 않는다.
- `record`는 값 중심의 불변 데이터 carrier에, sealed class/interface는 허용된 subtype 집합이 실제로 닫혀 있고 이를 유지할 책임이 있을 때 사용한다.

## 권장 패턴

- 생성 시 필수 값을 검증하고 가능한 한 불변 객체와 명시적인 method 계약을 사용한다.
- 상속보다 조합을 우선 검토하고, 상속은 subtype이 상위 타입의 계약을 완전히 대체할 수 있을 때만 사용한다.
- Collection 변환은 작은 단계와 의미 있는 이름으로 표현하며, 단순 누적이나 조기 종료가 중요하면 명시적 반복문을 선택한다.
- 언어 기능을 도입하기 전에 프로젝트가 선언한 Java 버전과 compiler 설정에서 지원되는지 확인한다.

## 금지 패턴

- `null`을 의미가 다른 여러 상태의 공통 표식으로 사용하지 않는다.
- `catch (Exception)`으로 모든 실패를 동일 처리하거나 원인 없이 새 exception으로 바꾸지 않는다.
- Stream pipeline에서 공유 mutable state를 갱신하거나 가독성을 해치는 중첩 pipeline을 만들지 않는다.
- 데이터 전달만을 이유로 불필요한 getter/setter 중심 mutable object를 만들지 않는다.
- 닫힌 subtype 집합이 아닌데 확장 제한만을 목적으로 sealed type을 사용하지 않는다.

## 검증 기준

- Public API의 null 허용 여부, exception 계약과 collection 수정 가능성이 일관되게 드러난다.
- 객체의 불변식이 생성 및 상태 변경 경계에서 보호되고 외부 mutable 참조로 우회되지 않는다.
- Stream과 반복문 선택이 부작용, 가독성과 성능 특성을 고려한다.
- `record`, sealed type 등 사용한 기능이 프로젝트의 Java 버전과 호환된다.
- 프로젝트가 선언한 compiler, 정적 분석과 관련 test가 통과하거나 미실행 사유가 보고된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Java 전용 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Java 타입, exception 또는 비동기 모델을 framework/platform lifecycle이나 외부 계약에 연결해야 할 때 bridge가 필요하다.
- 구체적인 annotation, component lifecycle과 framework test 규칙은 이 fragment에 추가하지 않는다.
