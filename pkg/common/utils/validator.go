package utils

import (
	"database/sql"
	"database/sql/driver"
	"reflect"

	"github.com/go-playground/locales/en"
	ut "github.com/go-playground/universal-translator"
	"github.com/go-playground/validator/v10"
	en_translations "github.com/go-playground/validator/v10/translations/en"
)

var (
	uni              *ut.UniversalTranslator
	translator       ut.Translator
	validateInstance *validator.Validate
)

func init() {

	// NOTE: ommitting allot of error checking for brevity

	en := en.New()
	uni = ut.New(en, en)

	// this is usually know or extracted from http 'Accept-Language' header
	// also see uni.FindTranslator(...)
	translator, _ = uni.GetTranslator("en")

	validateInstance = validator.New()

	registerCustomTypes(validateInstance)
	en_translations.RegisterDefaultTranslations(validateInstance, translator)

	translateOverride(translator)
}

func registerCustomTypes(validate *validator.Validate) {

	var ValidateValuer = func(field reflect.Value) interface{} {

		if valuer, ok := field.Interface().(driver.Valuer); ok {

			val, err := valuer.Value()

			if err == nil {
				return val
			}

			// handle the error how you want
		}

		return nil
	}

	validate.RegisterCustomTypeFunc(ValidateValuer, sql.NullString{}, sql.NullInt64{}, sql.NullBool{}, sql.NullFloat64{})

}

func translateOverride(trans ut.Translator) {

	validateInstance.RegisterTranslation("required", trans, func(ut ut.Translator) error {
		return ut.Add("required", "{0} is required!", true)
	}, func(ut ut.Translator, fe validator.FieldError) string {
		t, _ := ut.T("required", fe.Field())

		return t
	})

	validateInstance.RegisterTranslation("email", trans, func(ut ut.Translator) error {
		return ut.Add("email", "{0} must be a valid email address!", true)
	}, func(ut ut.Translator, fe validator.FieldError) string {
		t, _ := ut.T("email", fe.Field())

		return t
	})

	validateInstance.RegisterTranslation("len", trans, func(ut ut.Translator) error {
		return ut.Add("len", "{0} is not valid!", true)
	}, func(ut ut.Translator, fe validator.FieldError) string {
		t, _ := ut.T("len", fe.Field())

		return t
	})

}

type ValidatedFieldError struct {
	Field   string `json:"field"`
	Message string `json:"message"`
}

func Validate(value interface{}) (bool, *[]ValidatedFieldError) {

	err := validateInstance.Struct(value)

	if err != nil {

		errs := err.(validator.ValidationErrors)

		translated := errs.Translate(translator)

		validationErrors := []ValidatedFieldError{}

		for _, v := range errs {

			translatedMessage := ValidatedFieldError{
				Field:   v.Field(),
				Message: translated[v.Namespace()],
			}

			validationErrors = append(validationErrors, translatedMessage)
		}

		return false, &validationErrors
	}

	return true, nil
}
