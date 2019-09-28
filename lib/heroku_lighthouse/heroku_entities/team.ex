defmodule HerokuLighthouse.HerokuEntities.Team do
  # {
  #   "id": "01234567-89ab-cdef-0123-456789abcdef",
  #   "created_at": "2012-01-01T12:00:00Z",
  #   "credit_card_collections": true,
  #   "default": true,
  #   "enterprise_account": {
  #     "id": "01234567-89ab-cdef-0123-456789abcdef",
  #     "name": "example"
  #   },
  #   "identity_provider": {
  #     "id": "01234567-89ab-cdef-0123-456789abcdef",
  #     "slug": "acme-sso"
  #   },
  #   "membership_limit": 25,
  #   "name": "example",
  #   "provisioned_licenses": true,
  #   "role": "admin",
  #   "type": "team",
  #   "updated_at": "2012-01-01T12:00:00Z"
  # }
  defstruct [:id, :name]
end
