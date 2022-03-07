public inherited sharing virtual class tmo_soqlCriteriaBuilder {
  private String referenceFieldNamePreffix;
  private List<String> criteria;
  private List<Boolean> trueIfAndJoinElements;
  private Boolean nextJoinFlagValue;

  private tmo_soqlCriteriaBuilder() {
    referenceFieldNamePreffix = null;
    criteria = new List<String>();
    trueIfAndJoinElements = new List<Boolean>();
    nextJoinFlagValue = true;
  }

  public tmo_soqlCriteriaBuilder withOr() {
    nextJoinFlagValue = false;
    return this;
  }

  public tmo_soqlCriteriaBuilder withAnd() {
    nextJoinFlagValue = true;
    return this;
  }

  public String toCriteria() {
    List<String> finalCriteriaElements = new List<String>();
    Iterator<String> criteriaIterator = criteria.iterator();
    Iterator<Boolean> joinIterator = trueIfAndJoinElements.iterator();
    while (criteriaIterator.hasNext()) {
      finalCriteriaElements.add(criteriaIterator.next());
      if (joinIterator.hasNext()) {
        finalCriteriaElements.add(joinIterator.next() ? 'AND' : 'OR');
      }
    }
    return String.join(finalCriteriaElements, ' ');
  }

  public tmo_soqlCriteriaBuilder configureForReferenceField(Schema.SObjectField referenceField) {
    referenceFieldNamePreffix = referenceField.getDescribe().getRelationshipName() + '.';
    return this;
  }

  public tmo_soqlCriteriaBuilder equalsTo(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' = ' + fieldValue(field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder equalsTo(tmo_soqlDateFunction df, Integer fieldValue) {
    addCriteria(dateFunction(df) + ' = ' + fieldValue);
    return this;
  }

  private String dateFunction(tmo_soqlDateFunction df) {
    return df.dateFunction + wrapIntoBrackets(fieldName(df.field));
  }

  private String fieldName(Schema.SObjectField field) {
    String fieldName = field.getDescribe().getName();
    return referenceFieldNamePreffix != null ? referenceFieldNamePreffix + fieldName : fieldName;
  }

  protected virtual String fieldValue(Schema.SObjectField field, Object fieldValue) {
    String value = null;
    if (Schema.DisplayType.DATE.equals(field.getDescribe().getType())) {
      if (fieldValue instanceof Integer) {
        value = String.valueOf(fieldValue);
      } else {
        value = formatDate(fieldValue);
      }
    } else {
      value = wrapIntoQuotesIfString(fieldValue);
    }
    return value;
  }

  private String formatDate(Object dateOrString) {
    if (dateOrString instanceof String) {
      return String.valueOf(dateOrString);
    } else {
      Date dateValue = (Date) dateOrString;
      List<String> dateParts = new List<String>{
        withLeadingZero(dateValue.year()),
        withLeadingZero(dateValue.month()),
        withLeadingZero(dateValue.day())
      };
      return String.join(dateParts, '-');
    }
  }

  private String withLeadingZero(Integer oneTwoDigits) {
    return oneTwoDigits > 9 ? '' + oneTwoDigits : '0' + oneTwoDigits;
  }

  private String wrapIntoQuotesIfString(Object value) {
    if (value instanceof String) {
      return '\'' + value + '\'';
    }
    return '' + value;
  }

  public tmo_soqlCriteriaBuilder notEqualsTo(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' != ' + fieldValue(field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder notEqualsTo(tmo_soqlDateFunction df, Integer fieldValue) {
    addCriteria(dateFunction(df) + ' != ' + fieldValue(df.field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder greaterOrEqual(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' >= ' + fieldValue(field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder greaterOrEqual(tmo_soqlDateFunction df, Object fieldValue) {
    addCriteria(dateFunction(df) + ' >= ' + fieldValue(df.field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder greaterThan(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' > ' + fieldValue(field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder greaterThan(tmo_soqlDateFunction df, Object fieldValue) {
    addCriteria(dateFunction(df) + ' > ' + fieldValue(df.field, fieldValue));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder lessThan(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' < ' + fieldValue(field, fieldValue));
    return this;
  }

  public virtual tmo_soqlCriteriaBuilder lessThan(tmo_soqlDateFunction df, Object fieldValue) {
    addCriteria(dateFunction(df) + ' < ' + fieldValue(df.field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder lessOrEqual(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' <= ' + fieldValue(field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder lessOrEqual(tmo_soqlDateFunction df, Object fieldValue) {
    addCriteria(dateFunction(df) + ' <= ' + fieldValue(df.field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder isIn(Schema.SObjectField field, List<Object> inValues) {
    addCriteria(fieldName(field) + ' IN ' + fieldInValue(field, inValues));
    return this;
  }

  protected virtual String fieldInValue(Schema.SObjectField field, Object inValues) {
    String value = null;
    if (inValues instanceof List<Object>) {
      value = wrapIntoBrackets(convertToInValuesAsString((List<Object>) inValues));
    } else if (inValues instanceof String) {
      value = wrapIntoBrackets(String.valueOf(inValues));
    }
    return value;
  }

  public tmo_soqlCriteriaBuilder isIn(Schema.SObjectField field, String subSelect) {
    addCriteria(fieldName(field) + ' IN ' + fieldInValue(field, subSelect));
    return this;
  }

  public tmo_soqlCriteriaBuilder isIn(tmo_soqlDateFunction df, List<Integer> inValues) {
    addCriteria(dateFunction(df) + ' IN ' + fieldInValue(df.field, inValues));
    return this;
  }

  public tmo_soqlCriteriaBuilder isNotIn(Schema.SObjectField field, List<Object> inValues) {
    addCriteria(fieldName(field) + ' NOT IN ' + fieldInValue(field, inValues));
    return this;
  }

  public tmo_soqlCriteriaBuilder isNotIn(Schema.SObjectField field, String subSelect) {
    addCriteria(fieldName(field) + ' NOT IN ' + fieldInValue(field, subSelect));
    return this;
  }

  public tmo_soqlCriteriaBuilder isNotIn(tmo_soqlDateFunction df, List<Integer> inValues) {
    addCriteria(dateFunction(df) + ' NOT IN ' + fieldInValue(df.field, inValues));
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

  public tmo_soqlCriteriaBuilder composite(tmo_soqlCriteriaBuilder complexCriteria) {
    addCriteria(wrapIntoBrackets(complexCriteria.toCriteria()));
    return this;
  }

  public tmo_soqlCriteriaBuilder isLike(Schema.SObjectField field, String fieldValue) {
    addCriteria(fieldName(field) + ' LIKE ' + fieldValue(field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder isNotLike(Schema.SObjectField field, String fieldValue) {
    String singleCriteria = 'NOT ' + fieldName(field) + ' LIKE ' + fieldValue(field, fieldValue);
    addCriteria(wrapIntoBrackets(singleCriteria));
    return this;
  }

  public tmo_soqlCriteriaBuilder isNull(Schema.SObjectField field) {
    addCriteria(fieldName(field) + ' = NULL');
    return this;
  }

  public tmo_soqlCriteriaBuilder isNotNull(Schema.SObjectField field) {
    addCriteria(fieldName(field) + ' != NULL');
    return this;
  }

  private void addCriteria(String criterion) {
    if (!criteria.isEmpty()) {
      trueIfAndJoinElements.add(nextJoinFlagValue);
      withAnd();
    }
    criteria.add(criterion);
  }

  public static tmo_soqlCriteriaBuilder stringCriteriaBuilder() {
    return new tmo_soqlCriteriaBuilder();
  }

  public static tmo_soqlCriteriaBuilder bindingBuilder() {
    return new tmo_bindingSoqlCriteriaBuilder();
  }

  private inherited sharing class tmo_bindingSoqlCriteriaBuilder extends tmo_soqlCriteriaBuilder {
    protected override String fieldValue(Schema.SObjectField field, Object fieldValue) {
      failIfNotBindingVariable(fieldValue);
      return String.valueOf(fieldValue);
    }

    protected override String fieldInValue(Schema.SObjectField field, Object inValues) {
      failIfNotBindingVariable(inValues);
      return String.valueOf(inValues);
    }

    private void failIfNotBindingVariable(Object fieldValue) {
      if (!(fieldValue instanceof String) || !fieldValue?.toString().startsWith(':')) {
        throw new IllegalArgumentException('binding builder can work with Binding Variables only');
      }
    }
  }
}
