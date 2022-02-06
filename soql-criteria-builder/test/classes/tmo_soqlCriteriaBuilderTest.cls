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
  static void likeCriteria() {
    assertEquals('Name LIKE \'%force\'', cb.isLike(Account.Name, '%force'));
  }

  @isTest
  static void wrapsNotLikeCriteriaIntoBrackets() {
    assertEquals('(NOT Name LIKE \'%force\')', cb.isNotLike(Account.Name, '%force'));
  }

  @isTest
  static void joinsCriteriaViaAndByDefault() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.equalsTo(Account.Industry, 'IT').greaterOrEqual(Account.NumberOfEmployees, 100);

    System.assertEquals('Industry = \'IT\' AND NumberOfEmployees >= 100', cb.toCriteria());
  }

  @isTest
  static void canJoinViaOrIfConfigured() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.equalsTo(Account.Industry, 'IT').greaterOrEqual(Account.NumberOfEmployees, 100).joinViaOr();

    System.assertEquals('Industry = \'IT\' OR NumberOfEmployees >= 100', cb.toCriteria());
  }

  @isTest
  static void criteriaBasedOnReferenceAttributes() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();

    cb
      .configureCriteriaFactoryFields(Contact.AccountId)
      .equalsTo(Account.Industry, 'IT')
      .greaterOrEqual(Account.NumberOfEmployees, 100);

    System.assertEquals('Account.Industry = \'IT\' AND Account.NumberOfEmployees >= 100', cb.toCriteria());
  }

  // TODO: rewrite to not null and other examples
  @isTest
  static void wrapsCompositeCriteriaIntoBrackets() {
    tmo_soqlCriteriaBuilder compositeCriteria = new tmo_soqlCriteriaBuilder();
    compositeCriteria.equalsTo(Contact.Email, 'fieldValue').equalsTo(Contact.Title, 'title').joinViaOr();
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.equalsTo(Contact.Department, 'ABC').composite(compositeCriteria);

    System.assertEquals('Department = \'ABC\' AND (Email = \'fieldValue\' OR Title = \'title\')', cb.toCriteria());
  }

  private static void assertEquals(String expectedCriteria, tmo_soqlCriteriaBuilder criteriaBuilder) {
    System.assertEquals(expectedCriteria, criteriaBuilder.toCriteria());
  }
}
