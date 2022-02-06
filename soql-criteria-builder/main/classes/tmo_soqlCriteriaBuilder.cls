public inherited sharing class tmo_soqlCriteriaBuilder {
  private String referenceFieldNamePreffix;
  private String joinVia;
  private List<String> criteria;

  public tmo_soqlCriteriaBuilder() {
    referenceFieldNamePreffix = null;
    joinVia = ' AND ';
    criteria = new List<String>();
  }

  public tmo_soqlCriteriaBuilder joinViaOr() {
    joinVia = ' OR ';
    return this;
  }

  public String toCriteria() {
    return String.join(criteria, joinVia);
  }

  public tmo_soqlCriteriaBuilder configureCriteriaFactoryFields(
    Schema.SObjectField referenceField
  ) {
    referenceFieldNamePreffix =
      referenceField.getDescribe().getRelationshipName() + '.';
    return this;
  }

  public tmo_soqlCriteriaBuilder equalsTo(
    Schema.SObjectField field,
    Object fieldValue
  ) {
    String singleCriteria =
      fieldName(field) +
      ' = ' +
      wrapIntoQuotesIfString(fieldValue);
    criteria.add(singleCriteria);
    return this;
  }

  private String fieldName(Schema.SObjectField field) {
    String fieldName = field.getDescribe().getName();
    return referenceFieldNamePreffix != null
      ? referenceFieldNamePreffix + fieldName
      : fieldName;
  }

  private String wrapIntoQuotesIfString(Object value) {
    if (value instanceof String) {
      return '\'' + value + '\'';
    }
    return '' + value;
  }

  public tmo_soqlCriteriaBuilder greaterOrEqual(
    Schema.SObjectField field,
    Object numericValue
  ) {
    String singleCriteria = fieldName(field) + ' >= ' + numericValue;
    criteria.add(singleCriteria);
    return this;
  }

  public tmo_soqlCriteriaBuilder lessThan(
    Schema.SObjectField field,
    Object numericValue
  ) {
    String singleCriteria = fieldName(field) + ' < ' + numericValue;
    criteria.add(singleCriteria);
    return this;
  }

  public tmo_soqlCriteriaBuilder isIn(
    Schema.SObjectField field,
    List<Object> inValues
  ) {
    String singleCriteria =
      fieldName(field) +
      ' IN ' +
      wrapIntoBrackets(convertToInValuesAsString(inValues));
    criteria.add(singleCriteria);
    return this;
  }

  private String wrapIntoBrackets(String value) {
    return '(' + value + ')';
  }

  private String convertToInValuesAsString(List<Object> inValues) {
    if (inValues instanceof List<String>) {
      return convertToInString(inValues);
    }
    return String.join(inValues, ',');
  }

  private String convertToInString(List<Object> inValues) {
    return wrapIntoQuotesIfString(String.join(inValues, '\',\''));
  }

  public tmo_soqlCriteriaBuilder composite(
    tmo_soqlCriteriaBuilder complexCriteria
  ) {
    criteria.add(wrapIntoBrackets(complexCriteria.toCriteria()));
    return this;
  }

	public tmo_soqlCriteriaBuilder notEqualsTo(
    Schema.SObjectField field,
    Object fieldValue){
    criteria.add(fieldName(field) + ' != ' + wrapIntoQuotesIfString(fieldValue));
    return this;
	} 
}
