@isTest(isParallel=true)
private class tmo_soqlCriteriaBuilderTest {
  @isTest
  static void equalsToCriteriaForString() {
    assertEquals('Name = \'salesforce\'', cb().equalsTo(Account.Name, 'salesforce'));
  }

  @isTest
  static void equalsToCriteriaForBoolean() {
    assertEquals('HasOpportunityLineItem = true', cb().equalsTo(Opportunity.HasOpportunityLineItem, true));
  }

  @isTest
  static void equalsToCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity = 2', cb().equalsTo(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void equalsToCriteriaForDateField() {
    assertEquals('Birthdate = 1995-05-21', cb().equalsTo(Contact.Birthdate, Date.valueOf('1995-05-21')));
  }

  @isTest
  static void equalsToCriteriaForDateString() {
    assertEquals('Birthdate = 1995-05-21', cb().equalsTo(Contact.Birthdate, '1995-05-21'));
  }

  @isTest
  static void equalsToCriteriaForDateFunction() {
    assertEquals('CALENDAR_MONTH(Birthdate) = 12', cb().equalsTo(CALENDAR_MONTH(Contact.Birthdate), 12));
  }

  @isTest
  static void notEqualsToCriteriaForString() {
    assertEquals('Name != \'microsoft\'', cb().notEqualsTo(Account.Name, 'microsoft'));
  }

  @isTest
  static void notEqualsToCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity != 2', cb().notEqualsTo(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void notEqualsToCriteriaForDateField() {
    assertEquals('Birthdate != 1995-05-21', cb().notEqualsTo(Contact.Birthdate, Date.valueOf('1995-05-21')));
  }

  @isTest
  static void notEqualsToCriteriaForDateString() {
    assertEquals('Birthdate != 1995-05-21', cb().notEqualsTo(Contact.Birthdate, '1995-05-21'));
  }

  @isTest
  static void notEqualsToCriteriaForDateFunction() {
    assertEquals('CALENDAR_MONTH(Birthdate) != 1', cb().notEqualsTo(CALENDAR_MONTH(Contact.Birthdate), 1));
  }

  @isTest
  static void greaterOrEqualCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity >= 2', cb().greaterOrEqual(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void greaterOrEqualCriteriaForDateField() {
    assertEquals('Birthdate >= 1995-05-21', cb().greaterOrEqual(Contact.Birthdate, Date.valueOf('1995-05-21')));
  }

  @isTest
  static void greaterOrEqualCriteriaForDateString() {
    assertEquals('Birthdate >= 1995-05-21', cb().greaterOrEqual(Contact.Birthdate, '1995-05-21'));
  }

  @isTest
  static void greaterOrEqualCriteriaForDateFunction() {
    assertEquals('CALENDAR_MONTH(Birthdate) >= 1', cb().greaterOrEqual(CALENDAR_MONTH(Contact.Birthdate), 1));
  }

  @isTest
  static void greaterThanCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity > 2', cb().greaterThan(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void greaterThanCriteriaForDateField() {
    assertEquals('Birthdate > 1995-05-21', cb().greaterThan(Contact.Birthdate, Date.valueOf('1995-05-21')));
  }

  @isTest
  static void greaterThanCriteriaForDateString() {
    assertEquals('Birthdate > 1995-05-21', cb().greaterThan(Contact.Birthdate, '1995-05-21'));
  }

  @isTest
  static void greaterThanCriteriaForDateFunction() {
    assertEquals('CALENDAR_MONTH(Birthdate) > 1', cb().greaterThan(CALENDAR_MONTH(Contact.Birthdate), 1));
  }

  @isTest
  static void lessThanCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity < 2', cb().lessThan(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void lessThanCriteriaForDateField() {
    assertEquals('Birthdate < 1995-05-21', cb().lessThan(Contact.Birthdate, Date.valueOf('1995-05-21')));
  }

  @isTest
  static void lessThanCriteriaForDateString() {
    assertEquals('Birthdate < 1995-05-21', cb().lessThan(Contact.Birthdate, '1995-05-21'));
  }

  @isTest
  static void lessThanCriteriaForDateFunction() {
    assertEquals('CALENDAR_MONTH(Birthdate) < 6', cb().lessThan(CALENDAR_MONTH(Contact.Birthdate), 6));
  }

  @isTest
  static void lessOrEqualCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity <= 2', cb().lessOrEqual(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void lessOrEqualCriteriaForDateField() {
    assertEquals('Birthdate <= 1995-05-21', cb().lessOrEqual(Contact.Birthdate, Date.valueOf('1995-05-21')));
  }

  @isTest
  static void lessOrEqualCriteriaForDateString() {
    assertEquals('Birthdate <= 1995-05-21', cb().lessOrEqual(Contact.Birthdate, '1995-05-21'));
  }

  @isTest
  static void lessOrEqualCriteriaForDateFunction() {
    assertEquals('CALENDAR_MONTH(Birthdate) <= 6', cb().lessOrEqual(CALENDAR_MONTH(Contact.Birthdate), 6));
  }

  @isTest
  static void inCriteriaForStrings() {
    List<String> inValues = new List<String>{ 'BMW', 'Jeep' };
    assertEquals('Name IN (\'BMW\',\'Jeep\')', cb().isIn(Account.Name, inValues));
  }

  @isTest
  static void inCriteriaForNonStrings() {
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    assertEquals('NumberOfEmployees IN (1,2,3)', cb().isIn(Account.NumberOfEmployees, inValues));
  }

  @isTest
  static void inCriteriaForSubSelect() {
    String subSelect = 'SELECT Id FROM Account';
    assertEquals('AccountId IN (SELECT Id FROM Account)', cb().isIn(Contact.AccountId, subSelect));
  }

  @isTest
  static void inCriteriaForDateFunction() {
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    assertEquals('CALENDAR_MONTH(Birthdate) IN (1,2,3)', cb().isIn(CALENDAR_MONTH(Contact.Birthdate), inValues));
  }

  @isTest
  static void notInCriteriaForSubSelect() {
    String subSelect = 'SELECT Id FROM Account';
    assertEquals('AccountId NOT IN (SELECT Id FROM Account)', cb().isNotIn(Contact.AccountId, subSelect));
  }

  @isTest
  static void notInCriteriaForStrings() {
    List<String> inValues = new List<String>{ 'BMW', 'Jeep' };
    assertEquals('Name NOT IN (\'BMW\',\'Jeep\')', cb().isNotIn(Account.Name, inValues));
  }

  @isTest
  static void notInCriteriaForNonStrings() {
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    assertEquals('NumberOfEmployees NOT IN (1,2,3)', cb().isNotIn(Account.NumberOfEmployees, inValues));
  }

  @isTest
  static void notInCriteriaForDateFunction() {
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    assertEquals('CALENDAR_MONTH(Birthdate) NOT IN (1,2,3)', cb().isNotIn(CALENDAR_MONTH(Contact.Birthdate), inValues));
  }

  @isTest
  static void likeCriteria() {
    assertEquals('Name LIKE \'%force\'', cb().isLike(Account.Name, '%force'));
  }

  @isTest
  static void wrapsNotLikeCriteriaIntoBrackets() {
    assertEquals('(NOT Name LIKE \'%force\')', cb().isNotLike(Account.Name, '%force'));
  }

  @isTest
  static void isNull() {
    assertEquals('Name = NULL', cb().isNull(Account.Name));
  }

  @isTest
  static void isNotNull() {
    assertEquals('Name != NULL', cb().isNotNull(Account.Name));
  }

  @isTest
  static void joinsCriteriaViaAndByDefault() {
    assertEquals(
      'Industry != NULL AND NumberOfEmployees >= 100',
      cb().isNotNull(Account.Industry).greaterOrEqual(Account.NumberOfEmployees, 100)
    );
  }

  @isTest
  static void canJoinViaOrIfConfigured() {
    assertEquals(
      'Industry != NULL OR NumberOfEmployees >= 100',
      cb().isNotNull(Account.Industry).withOr().greaterOrEqual(Account.NumberOfEmployees, 100)
    );
  }

  @isTest
  static void criteriaBasedOnReferenceAttributes() {
    assertEquals(
      'Account.Industry != NULL AND Account.NumberOfEmployees >= 100',
      cb()
        .configureForReferenceField(Contact.AccountId)
        .isNotNull(Account.Industry)
        .greaterOrEqual(Account.NumberOfEmployees, 100)
    );
  }

  @isTest
  static void dateFunctionCriteriaBasedOnReferenceAttributes() {
    assertEquals(
      'CALENDAR_MONTH(Opportunity.CloseDate) = 3',
      cb()
        .configureForReferenceField(OpportunityLineItem.OpportunityId)
        .equalsTo(CALENDAR_MONTH(Opportunity.CloseDate), 3)
    );
  }

  @isTest
  static void wrapsCompositeCriteriaIntoBrackets() {
    assertEquals(
      'Department LIKE \'Finance%\' AND (Email = NULL OR Title != NULL)',
      cb()
        .isLike(Contact.Department, 'Finance%')
        .composite(cb().isNull(Contact.Email).withOr().isNotNull(Contact.Title))
    );
  }

  @isTest
  static void bindingBuilderUsesBindingVariables() {
    assertEquals('Name = :companyName', cb().equalsTo(Account.Name, ':companyName'));
    assertEquals('Name != :companyName', cb().notEqualsTo(Account.Name, ':companyName'));
    assertEquals('Birthdate = :birthDate', cb().equalsTo(Contact.Birthdate, ':birthDate'));
    assertEquals('NumberOfEmployees > :value', cb().greaterThan(Account.NumberOfEmployees, ':value'));
    assertEquals('Birthdate > :birthDate', cb().greaterThan(Contact.Birthdate, ':birthDate'));
    assertEquals('NumberOfEmployees >= :value', cb().greaterOrEqual(Account.NumberOfEmployees, ':value'));
    assertEquals('Birthdate >= :birthDate', cb().greaterOrEqual(Contact.Birthdate, ':birthDate'));
    assertEquals('NumberOfEmployees < :value', cb().lessThan(Account.NumberOfEmployees, ':value'));
    assertEquals('Birthdate < :birthDate', cb().lessThan(Contact.Birthdate, ':birthDate'));
    assertEquals('NumberOfEmployees <= :value', cb().lessOrEqual(Account.NumberOfEmployees, ':value'));
    assertEquals('Birthdate <= :birthDate', cb().lessOrEqual(Contact.Birthdate, ':birthDate'));
    assertEquals('Name = NULL', cb().isNull(Account.Name));
    assertEquals('Birthdate = NULL', cb().isNull(Contact.Birthdate));
    assertEquals('Name != NULL', cb().isNotNull(Account.Name));
    assertEquals('Birthdate != NULL', cb().isNotNull(Contact.Birthdate));
    assertEquals('Name IN (:inValues)', cb().isIn(Account.Name, ':inValues'));
    assertEquals('Birthdate IN (:inValues)', cb().isIn(Contact.Birthdate, ':inValues'));
    assertEquals('Name NOT IN (:inValues)', cb().isNotIn(Account.Name, ':inValues'));
    assertEquals('Birthdate NOT IN (:inValues)', cb().isNotIn(Contact.Birthdate, ':inValues'));
    assertEquals('Name LIKE :likeValue', cb().isLike(Account.Name, ':likeValue'));
    assertEquals('(NOT Name LIKE :likeValue)', cb().isNotLike(Account.Name, ':likeValue'));
  }

  @isTest
  static void combinesStaticValuesAndBindingVariables() {
    assertEquals(
      'Department LIKE \'Finance%\' AND Email = :theEmail',
      cb().isLike(Contact.Department, 'Finance%').equalsTo(Contact.Email, ':theEmail')
    );
  }

  @isTest
  static void cannotExceed4000CharactersInWhereClause() {
    String criteria = 'CALENDAR_MONTH(Birthdate) = 1';
    String joinCondition = ' AND ';
    Integer theLimit = 4000;
    Integer failOnIterationNumber = (theLimit + joinCondition.length()) / (joinCondition.length() + criteria.length());
    Boolean exceptionThrown = false;
    Integer latestIndex = 0;
    tmo_soqlCriteriaBuilder cb = cb();

    try {
      do {
        cb.equalsTo(CALENDAR_MONTH(Contact.Birthdate), 1);
      } while (latestIndex++ < theLimit);
    } catch (Exception e) {
      exceptionThrown = true;
    }

    System.assert(exceptionThrown, 'should throw exception if where clause exeeds 4000');
    System.assertEquals(failOnIterationNumber, latestIndex);
  }

  private static tmo_soqlCriteriaBuilder cb() {
    return tmo_soqlCriteriaBuilder.builder();
  }

  private static void assertEquals(String expectedCriteria, tmo_soqlCriteriaBuilder criteriaBuilder) {
    System.assertEquals(expectedCriteria, criteriaBuilder.toCriteria());
  }

  private static tmo_soqlDateFunction CALENDAR_MONTH(Schema.SObjectField field) {
    return tmo_soqlDateFunction.dateFunction(tmo_soqlDateFunction.DateFunction.CALENDAR_MONTH, field);
  }
}
