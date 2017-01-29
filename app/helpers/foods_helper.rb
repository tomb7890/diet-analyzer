# coding: utf-8
module FoodsHelper

  include Nutrients

  def tab_pane_nutrients(category)
    y = case category
        when 'Vitamins'
          [
            [VITA_IU, 'IU'],
            [FOL, 'µg'],
            [THIA, 'mg'],
            [RIBF, 'mg'],
            [NIA, 'mg'],
            [PANTAC, 'mg'],
            [VITB6A, 'mg'],
            [VITB12, 'µg'],
            [VITC, 'mg'],
            [VITD, 'µg'],
            [TOCPHA, 'mg'],
            [VITK1,  'µg']
          ]
        when 'Minerals'
          [
            [CA, 'mg'],
            [CU, 'mg'],
            [FE, 'mg'],
            [MG, 'mg'],
            [MN, 'mg'],
            [P, 'mg'],
            [K, 'mg'],
            [SE, 'µg'],
            [NA, 'mg'],
            [ZN, 'mg']
          ]
        when 'Lipids'
          [
            [FASAT, 'g'],
            [FAMS, 'g'],
            [FAPU, 'g'],
            [CHOLE, 'mg'],
            [FATRN, 'mg'],
            ['Omega 3', 'g'],
            ['Omega 6', 'g'],
            [F18D3CN3, 'g'],
            [F20D3N3, 'mg'],
            [F22D6, 'mg'],
            [F20D5, 'mg'],
            [F22D5, 'mg']
          ]

        when 'Amino Acids'
          [
            [ALA_G, 'g'],
            [ARG_G, 'g'],
            [ASP_G, 'g'],
            [CYS_G, 'g'],
            [GLU_G, 'g'],
            [GLY_G, 'g'],
            [HISTN_G, 'g'],
            [HYP, 'g'],
            [ILE_G, 'g'],
            [LEU_G, 'g'],
            [LYS_G, 'g'],
            [MET_G, 'g'],
            [PHE_G, 'g'],
            [PRO_G, 'g'],
            [SER_G, 'g'],
            [THR_G, 'g'],
            [TRP_G, 'g'],
            [TYR_G, 'g'],
            [VAL_G, 'g']
          ]
        end
    y
  end

end
