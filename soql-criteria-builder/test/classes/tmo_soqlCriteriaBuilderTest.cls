@isTest(isParallel=true)
private class tmo_soqlCriteriaBuilderTest {
  private final static tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();

  @isTest
  static void equalsToCriteriaForString() {
    assertEquals('Name = \'salesforce\'', cb.equalsTo(Account.Name, 'salesforce'));
  }

  @isTest
  static void equalsToCriteriaForBoolean() {
    assertEquals('HasOpportunityLineItem = true', cb.equalsTo(Opportunity.HasOpportunityLineItem, true));
  }

  @isTest
  static void equalsToCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity = 2', cb.equalsTo(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void notEqualsToCriteriaForString() {
    assertEquals('Name != \'microsoft\'', cb.notEqualsTo(Account.Name, 'microsoft'));
  }

  @isTest
  static void notEqualsToCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity != 2', cb.notEqualsTo(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void greaterOrEqualCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity >= 2', cb.greaterOrEqual(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void greaterThanCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity > 2', cb.greaterThan(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void lessThanCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity < 2', cb.lessThan(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void lessOrEqualCriteriaForNumeric() {
    assertEquals('TotalOpportunityQuantity <= 2', cb.lessOrEqual(Opportunity.TotalOpportunityQuantity, 2));
  }

  @isTest
  static void inCriteriaForStrings() {
    List<String> inValues = new List<String>{ 'BMW', 'Jeep' };
    assertEquals('Name IN (\'BMW\',\'Jeep\')', cb.isIn(Account.Name, inValues));
  }

  @isTest
  static void inCriteriaForNonStrings() {
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    assertEquals('NumberOfEmployees IN (1,2,3)', cb.isIn(Account.NumberOfEmployees, inValues));
  }

  @isTest
  static void inCriteriaForSubSelect() {
    String subSelect = 'SELECT Id FROM Account';
    assertEquals('AccountId IN (SELECT Id FROM Account)', cb.isIn(Contact.AccountId, subSelect));
  }

  @isTest
  static void notInCriteriaForSubSelect() {
    String subSelect = 'SELECT Id FROM Account';
    assertEquals('AccountId NOT IN (SELECT Id FROM Account)', cb.isNotIn(Contact.AccountId, subSelect));
  }

  @isTest
  static void notInCriteriaForStrings() {
    List<String> inValues = new List<String>{ 'BMW', 'Jeep' };
    assertEquals('Name NOT IN (\'BMW\',\'Jeep\')', cb.isNotIn(Account.Name, inValues));
  }

  @isTest
  static void notInCriteriaForNonStrings() {
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    assertEquals('NumberOfEmployees NOT IN (1,2,3)', cb.isNotIn(Account.NumberOfEmployees, inValues));
  }

  @isTest
  static void likeCriteria() {
    assertEquals('Name LIKE \'%force\'', cb.isLike(Account.Name, '%force'));
  }

  @isTest
  static void wrapsNotLikeCriteriaIntoBrackets() {
    assertEquals('(NOT Name LIKE \'%force\')', cb.isNotLike(Account.Name, '%force'));
  }

  @isTest
  static void isNull() {
    assertEquals('Name = NULL', cb.isNull(Account.Name));
  }

  @isTest
  static void isNotNull() {
    assertEquals('Name != NULL', cb.isNotNull(Account.Name));
  }

  @isTest
  static void joinsCriteriaViaAndByDefault() {
    cb.isNotNull(Account.Industry).greaterOrEqual(Account.NumberOfEmployees, 100);

    System.assertEquals('Industry != NULL AND NumberOfEmployees >= 100', cb.toCriteria());
  }

  @isTest
  static void canJoinViaOrIfConfigured() {
    cb.isNotNull(Account.Industry).withOr().greaterOrEqual(Account.NumberOfEmployees, 100);

    System.assertEquals('Industry != NULL OR NumberOfEmployees >= 100', cb.toCriteria());
  }

  @isTest
  static void criteriaBasedOnReferenceAttributes() {
    cb
      .configureForReferenceField(Contact.AccountId)
      .isNotNull(Account.Industry)
      .greaterOrEqual(Account.NumberOfEmployees, 100);

    System.assertEquals('Account.Industry != NULL AND Account.NumberOfEmployees >= 100', cb.toCriteria());
  }

  @isTest
  static void wrapsCompositeCriteriaIntoBrackets() {
    tmo_soqlCriteriaBuilder compositeCriteria = new tmo_soqlCriteriaBuilder();
    compositeCriteria.isNull(Contact.Email).withOr().isNotNull(Contact.Title);
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.isLike(Contact.Department, 'Finance%').composite(compositeCriteria);

    System.assertEquals('Department LIKE \'Finance%\' AND (Email = NULL OR Title != NULL)', cb.toCriteria());
  }

  private static void assertEquals(String expectedCriteria, tmo_soqlCriteriaBuilder criteriaBuilder) {
    System.assertEquals(expectedCriteria, criteriaBuilder.toCriteria());
  }
}
