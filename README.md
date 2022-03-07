# SOQL Criteria Builder

DSL support for building SOQL WHERE Clause in an elegant way.  
Inspired by [fflib_QueryFactory](https://github.com/apex-enterprise-patterns/fflib-apex-common/blob/master/sfdx-source/apex-common/main/classes/fflib_QueryFactory.cls).  
Addresses necessity to build criteria as String for [fflib_QueryFactory#setCondition()](https://github.com/apex-enterprise-patterns/fflib-apex-common/blob/397fa3574bf57866660d6737e2060f2f171d130a/sfdx-source/apex-common/main/classes/fflib_QueryFactory.cls#L298) method.

<a href="https://githubsfdeploy.herokuapp.com?owner=testmyorgdotcom&repo=soql-criteria-builder&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Examples

### Simple Criteria

```java
String simpleCriteria = 'AccountId != NULL AND (NOT LastName LIKE \'A%\') AND Department = \'Finance\'';

tmo_soqlCriteriaBuilder cb = cb()
    .isNotNull(Contact.AccountId)
    .isNotLike(Contact.LastName, 'Aza%')
    .equalsTo(Contact.Department, 'Finance');

System.assertEquals(simpleCriteria, cb.toCriteria());
```

### Between Criteria

```java
String betweenCriteria = 'NumberOfEmployees > 1000 AND NumberOfEmployees < 2000';

tmo_soqlCriteriaBuilder cb = cb()
    .greaterThan(Account.NumberOfEmployees, 1000)
    .lessThan(Account.NumberOfEmployees, 2000);

System.assertEquals(betweenCriteria, cb.toCriteria());
```

### Dynamic Criteria

```java
String dynamicCriteria = 'Title != NULL AND AccountId != NULL AND (Account.NumberOfEmployees > 9)';

Boolean userRequestedBigCompaniesOnly = true;
tmo_soqlCriteriaBuilder cb = cb().isNotNull(Contact.Title);
if(userRequestedBigCompaniesOnly) {
    cb
        .isNotNull(Contact.AccountId)
        .composite(
            cb()
                .configureForReferenceField(Contact.AccountId)
                .greaterThan(Account.NumberOfEmployees, 9)
        );
}

System.assertEquals(dynamicCriteria, cb.toCriteria());
```

### Complex Criteria

```java
String complexCriteria = 'IsWon = true AND Amount > 100000 AND'
    + ' ((Account.NumberOfEmployees > 1000 AND Account.BillingCountry = \'USA\') OR (Owner.Title = \'CEO\' AND Owner.Country = \'USA\'))';

tmo_soqlCriteriaBuilder bigUsCompanies = cb()
    .configureForReferenceField(Opportunity.AccountId)
    .greaterThan(Account.NumberOfEmployees, 1000)
    .equalsTo(Account.BillingCountry, 'USA');

tmo_soqlCriteriaBuilder ownerInUs = cb()
    .configureForReferenceField(Opportunity.OwnerId)
    .equalsTo(User.Title, 'CEO')
    .equalsTo(User.Country, 'USA');

tmo_soqlCriteriaBuilder cb = cb()
    .equalsTo(Opportunity.IsWon, true)
    .greaterThan(Opportunity.Amount, 100000)
    .composite(
        cb()
            .composite(bigUsCompanies)
            .withOr()
            .composite(ownerInUs)
    );

System.assertEquals(complexCriteria, cb.toCriteria());
```

### Criteria with Date Functions

```java
String dateFunctionCriteria = 'CALENDAR_MONTH(Birthdate) > 1';

tmo_soqlCriteriaBuilder cb = cb().greaterThan(CALENDAR_MONTH(Contact.Birthdate), 1');

System.assertEquals(dateFunctionCriteria, cb.toCriteria());
```

Examples were built under assumption of the following factory methods presence:

```java
private static tmo_soqlCriteriaBuilder cb() {
    return tmo_soqlCriteriaBuilder.stringCriteriaBuilder();
}

private static tmo_soqlDateFunction CALENDAR_MONTH(Schema.SObjectField field) {
    return tmo_soqlDateFunction.dateFunction(tmo_soqlDateFunction.DateFunction.CALENDAR_MONTH, field);
}
```

## Benefits

- Supports all [Comparison Operators](https://developer.salesforce.com/docs/atlas.en-us.232.0.soql_sosl.meta/soql_sosl/sforce_api_calls_soql_select_comparisonoperators.htm)
- Compile Time validation of the Field Names used in SOQL Criteria
- Dynamic SOQL Criteria based on User input
- Bind Variables
- [Date Functions](https://developer.salesforce.com/docs/atlas.en-us.232.0.soql_sosl.meta/soql_sosl/sforce_api_calls_soql_select_date_functions.htm) support

## Additional Thoughts

Prefer queries with `:bindVariables` instead of dynamically built ones.  
Underlying databases (e.g. [Oracle](https://blogs.oracle.com/sql/post/improve-sql-query-performance-by-using-bind-variables)) will create additional plan for every similar query built dynamically. This will decrease performance of the database and will require additional resources to optimize it in the background.

Below examples are built under assumption of the following factory method presence:

```java
private static tmo_soqlCriteriaBuilder bb() {
    return tmo_soqlCriteriaBuilder.bindingBuilder();
}
```

```java
assertEquals('Name = :companyName', bb().equalsTo(Account.Name, ':companyName'));
assertEquals('Name IN :inValues', bb().isIn(Account.Name, ':inValues'));
```
