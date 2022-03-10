public inherited sharing class tmo_soqlCriteriaBuilder {
  private static final String AND_JOIN = 'AND';
  private static final String OR_JOIN = 'OR';
  private static final String EXPRESSION_JOIN = ' ';
  private String referenceFieldNamePreffix;
  private List<String> criteria;
  private List<Boolean> trueIfAndJoinElements;
  private Boolean nextJoinFlagValue;
  private CriteriaSize sizeMonitor;

  private tmo_soqlCriteriaBuilder() {
    referenceFieldNamePreffix = null;
    criteria = new List<String>();
    trueIfAndJoinElements = new List<Boolean>();
    nextJoinFlagValue = true;
    sizeMonitor = new CriteriaSize();
  }

  public static tmo_soqlCriteriaBuilder builder() {
    return new tmo_soqlCriteriaBuilder();
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
        finalCriteriaElements.add(joinIterator.next() ? AND_JOIN : OR_JOIN);
      }
    }
    return String.join(finalCriteriaElements, EXPRESSION_JOIN);
  }

  public tmo_soqlCriteriaBuilder configureForReferenceField(Schema.SObjectField referenceField) {
    referenceFieldNamePreffix = referenceField.getDescribe().getRelationshipName() + '.';
    return this;
  }

  public tmo_soqlCriteriaBuilder equalsTo(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' = ' + fieldValue(field, fieldValue));
    return this;
  }

  private String fieldName(Schema.SObjectField field) {
    String fieldName = field.getDescribe().getName();
    return referenceFieldNamePreffix != null ? referenceFieldNamePreffix + fieldName : fieldName;
  }

  private String fieldValue(Schema.SObjectField field, Object fieldValue) {
    String value = null;
    if (Schema.DisplayType.DATE.equals(field.getDescribe().getType())) {
      if (fieldValue instanceof Datetime) {
        value = formatDate(fieldValue);
      } else {
        value = String.valueOf(fieldValue);
      }
    } else if (Schema.DisplayType.DATETIME.equals(field.getDescribe().getType())) {
      if (fieldValue instanceof Datetime) {
        value = formatDatetime(fieldValue);
      } else {
        value = String.valueOf(fieldValue);
      }
    } else {
      value = presentAsString(fieldValue);
    }
    return value;
  }

  private String formatDate(Object dateOrString) {
    Date dateValue = (Date) dateOrString;
    List<String> dateParts = new List<String>{
      withLeadingZero(dateValue.year()),
      withLeadingZero(dateValue.month()),
      withLeadingZero(dateValue.day())
    };
    return String.join(dateParts, '-');
  }

  private String formatDatetime(Object dt) {
    Datetime dateTimeValue = (Datetime) dt;
    Time timeValue = dateTimeValue.timeGmt();
    List<String> timeParts = new List<String>{
      withLeadingZero(timeValue.hour()),
      withLeadingZero(timeValue.minute()),
      withLeadingZero(timeValue.second())
    };
    return formatDate(dateTimeValue.dateGmt()) + 'T' + String.join(timeParts, ':') + 'Z';
  }

  private String withLeadingZero(Integer oneTwoDigits) {
    return oneTwoDigits > 9 ? '' + oneTwoDigits : '0' + oneTwoDigits;
  }

  //TODO: rename function to reflect the intent
  private String presentAsString(Object valueObj) {
    String value = String.valueOf(valueObj);
    if (valueObj instanceof String) {
      return value.startsWith(':') ? value : '\'' + value + '\'';
    }
    return value;
  }

  public tmo_soqlCriteriaBuilder equalsTo(tmo_soqlDateFunction df, Integer fieldValue) {
    addCriteria(dateFunction(df) + ' = ' + fieldValue);
    return this;
  }

  private String dateFunction(tmo_soqlDateFunction df) {
    return df.dateFunction + wrapIntoBrackets(fieldName(df.field));
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

  public tmo_soqlCriteriaBuilder lessThan(Schema.SObjectField field, Object fieldValue) {
    addCriteria(fieldName(field) + ' < ' + fieldValue(field, fieldValue));
    return this;
  }

  public tmo_soqlCriteriaBuilder lessThan(tmo_soqlDateFunction df, Object fieldValue) {
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

  private String fieldInValue(Schema.SObjectField field, Object inValues) {
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
    return presentAsString(String.join(inValues, '\',\''));
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
      sizeMonitor.register(nextJoinFlagValue);
      trueIfAndJoinElements.add(nextJoinFlagValue);
      withAnd();
    }
    criteria.add(criterion);
    sizeMonitor.register(criterion);
  }

  private class CriteriaSize {
    private final Integer whereLimit = 4000;
    private Integer criteriaSize = 0;

    private void register(Boolean trueIfAndJoinElement) {
      criteriaSize += trueIfAndJoinElement ? AND_JOIN.length() : OR_JOIN.length();
      criteriaSize += 2 * EXPRESSION_JOIN.length();
      failIfLimitBreached();
    }

    private void register(String criterion) {
      criteriaSize += criterion.length();
      failIfLimitBreached();
    }

    private void failIfLimitBreached() {
      if (whereLimit < criteriaSize) {
        throw new tmo_WhereClauseLimitException();
      }
    }
  }

  public class tmo_WhereClauseLimitException extends Exception {
  }

  public static tmo_soqlDateFunction dateFunction(DateFunction df, Schema.SObjectField field) {
    tmo_soqlDateFunction result = new tmo_soqlDateFunction();
    result.field = field;
    result.dateFunction = df;
    return result;
  }

  public class tmo_soqlDateFunction {
    public Schema.SObjectField field { get; set; }
    public DateFunction dateFunction;
  }

  public enum DateFunction {
    CALENDAR_MONTH,
    CALENDAR_QUARTER,
    CALENDAR_YEAR,
    DAY_IN_MONTH,
    DAY_IN_WEEK,
    DAY_IN_YEAR,
    DAY_ONLY,
    FISCAL_MONTH,
    FISCAL_QUARTER,
    FISCAL_YEAR,
    HOUR_IN_DAY,
    WEEK_IN_MONTH,
    WEEK_IN_YEAR
  }
}
