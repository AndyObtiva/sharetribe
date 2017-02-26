module CustomLandingPage
  class LandingPageStoreStatic

    def initialize(released_version)
      @_released_version = released_version || 1
    end

    def released_version(*)
      @_released_version
    end

    def load_structure(*)
      structure_name = APP_CONFIG.structure_name || 'DATA_STR'
      JSON.parse(CustomLandingPage::ExampleData.const_get(structure_name))
    end

    def enabled?(cid)
      true
    end
  end
end
