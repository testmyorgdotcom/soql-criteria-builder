@isTest(isParallel=true)
private class tmo_soqlCriteriaBuilderTest {
  @isTest
  static void equalsCriteriaForString() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    cf.equalTo(Account.Name, 'salesforce');

    System.assertEquals('Name = \'salesforce\'', cf.toCriteria());
  }

  @isTest
  static void equalsCriteriaForBoolean() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    cf.equalTo(Opportunity.HasOpportunityLineItem, true);

    System.assertEquals('HasOpportunityLineItem = true', cf.toCriteria());
  }

  @isTest
  static void equalsCriteriaForNumeric() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    cf.equalTo(Opportunity.TotalOpportunityQuantity, 2);

    System.assertEquals('TotalOpportunityQuantity = 2', cf.toCriteria());
  }

  @isTest
  static void greaterThanOrEqualCriteriaForNumeric() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    cf.greaterThanOrEqual(Opportunity.TotalOpportunityQuantity, 2);

    System.assertEquals('TotalOpportunityQuantity >= 2', cf.toCriteria());
  }

  @isTest
  static void lessThanCriteriaForNumeric() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    cf.lessThan(Opportunity.TotalOpportunityQuantity, 2);

    System.assertEquals('TotalOpportunityQuantity < 2', cf.toCriteria());
  }

  @isTest
  static void inCriteriaForStrings() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    List<String> inValues = new List<String>{ 'BMW', 'Jeep' };
    cf.isIn(Account.Name, inValues);

    System.assertEquals('Name IN (\'BMW\',\'Jeep\')', cf.toCriteria());
  }

  @isTest
  static void inCriteriaForNonStrings() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    List<Integer> inValues = new List<Integer>{ 1, 2, 3 };
    cf.isIn(Account.NumberOfEmployees, inValues);

    System.assertEquals('NumberOfEmployees IN (1,2,3)', cf.toCriteria());
  }

  @isTest
  static void joinsCriteriaViaAndByDefault() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    cf
      .equalTo(Account.Industry, 'IT')
      .greaterThanOrEqual(Account.NumberOfEmployees, 100);

    System.assertEquals(
      'Industry = \'IT\' AND NumberOfEmployees >= 100',
      cf.toCriteria()
    );
  }

  @isTest
  static void canJoinViaOrIfConfigured() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    cf
      .equalTo(Account.Industry, 'IT')
      .greaterThanOrEqual(Account.NumberOfEmployees, 100)
      .joinViaOr();

    System.assertEquals(
      'Industry = \'IT\' OR NumberOfEmployees >= 100',
      cf.toCriteria()
    );
  }

  @isTest
  static void criteriaBasedOnReferenceAttributes() {
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();

    cf
      .configureCriteriaFactoryFields(Contact.AccountId)
      .equalTo(Account.Industry, 'IT')
      .greaterThanOrEqual(Account.NumberOfEmployees, 100);

    System.assertEquals(
      'Account.Industry = \'IT\' AND Account.NumberOfEmployees >= 100',
      cf.toCriteria()
    );
  }

  // TODO: rewrite to not null and other examples
  @isTest
  static void wrapsCompositeCriteriaIntoBrackets() {
    tmo_soqlCriteriaBuilder compositeCriteria = new fflib_CriteriaFactory();
    compositeCriteria
      .equalTo(Contact.Email, 'fieldValue')
      .equalTo(Contact.Title, 'title')
      .joinViaOr();
    tmo_soqlCriteriaBuilder cf = new fflib_CriteriaFactory();
    cf.equalTo(Contact.Department, 'ABC').composite(compositeCriteria);

    System.assertEquals(
      'Department = \'ABC\' AND (Email = \'fieldValue\' OR Title = \'title\')',
      cf.toCriteria()
    );
  }
}
