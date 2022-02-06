@isTest(isParallel=true)
private class tmo_soqlCriteriaBuilderTest {
  @isTest
  static void equalsToCriteriaForString() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.equalsTo(Account.Name, 'salesforce');

    System.assertEquals('Name = \'salesforce\'', cb.toCriteria());
  }

  @isTest
  static void equalsToCriteriaForBoolean() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.equalsTo(Opportunity.HasOpportunityLineItem, true);

    System.assertEquals('HasOpportunityLineItem = true', cb.toCriteria());
  }

  @isTest
  static void equalsToCriteriaForNumeric() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.equalsTo(Opportunity.TotalOpportunityQuantity, 2);

    System.assertEquals('TotalOpportunityQuantity = 2', cb.toCriteria());
  }

  @isTest
  static void greaterOrEqualCriteriaForNumeric() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.greaterOrEqual(Opportunity.TotalOpportunityQuantity, 2);

    System.assertEquals('TotalOpportunityQuantity >= 2', cb.toCriteria());
  }

  @isTest
  static void lessThanCriteriaForNumeric() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.lessThan(Opportunity.TotalOpportunityQuantity, 2);

    System.assertEquals('TotalOpportunityQuantity < 2', cb.toCriteria());
  }

  @isTest
  static void inCriteriaForStrings() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    List<String> inValues = new List<String>{ 'BMW', 'Jeep' };
    cb.isIn(Account.Name, inValues);

    System.assertEquals('Name IN (\'BMW\',\'Jeep\')', cb.toCriteria());
  }

  @isTest
  static void inCriteriaForNonStrings() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    cb.isIn(Account.NumberOfEmployees, inValues);

    System.assertEquals('NumberOfEmployees IN (1,2,3)', cb.toCriteria());
  }

  @isTest
  static void joinsCriteriaViaAndByDefault() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb
      .equalsTo(Account.Industry, 'IT')
      .greaterOrEqual(Account.NumberOfEmployees, 100);

    System.assertEquals(
      'Industry = \'IT\' AND NumberOfEmployees >= 100',
      cb.toCriteria()
    );
  }

  @isTest
  static void canJoinViaOrIfConfigured() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb
      .equalsTo(Account.Industry, 'IT')
      .greaterOrEqual(Account.NumberOfEmployees, 100)
      .joinViaOr();

    System.assertEquals(
      'Industry = \'IT\' OR NumberOfEmployees >= 100',
      cb.toCriteria()
    );
  }

  @isTest
  static void criteriaBasedOnReferenceAttributes() {
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();

    cb
      .configureCriteriaFactoryFields(Contact.AccountId)
      .equalsTo(Account.Industry, 'IT')
      .greaterOrEqual(Account.NumberOfEmployees, 100);

    System.assertEquals(
      'Account.Industry = \'IT\' AND Account.NumberOfEmployees >= 100',
      cb.toCriteria()
    );
  }

  // TODO: rewrite to not null and other examples
  @isTest
  static void wrapsCompositeCriteriaIntoBrackets() {
    tmo_soqlCriteriaBuilder compositeCriteria = new tmo_soqlCriteriaBuilder();
    compositeCriteria
      .equalsTo(Contact.Email, 'fieldValue')
      .equalsTo(Contact.Title, 'title')
      .joinViaOr();
    tmo_soqlCriteriaBuilder cb = new tmo_soqlCriteriaBuilder();
    cb.equalsTo(Contact.Department, 'ABC').composite(compositeCriteria);

    System.assertEquals(
      'Department = \'ABC\' AND (Email = \'fieldValue\' OR Title = \'title\')',
      cb.toCriteria()
    );
  }
}
