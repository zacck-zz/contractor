# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Contractor.Repo.insert!(%Contractor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Contractor.Factory

vodafone = insert(:vendor, name: "Vodafone")
o2 = insert(:vendor, name: "O2")
vattenfall = insert(:vendor, name: "Vattenfall")
mcfit = insert(:vendor, name: "McFit")
sky = insert(:vendor, name: "Sky")


v_internet = %{name: "Internet", vendor: vodafone}
v_dsl = %{name: "DSL", vendor: vodafone}
v_phone = %{name: "Phone", vendor: vodafone}
v_m = %{name: "Mobile Phone", vendor: vodafone}
insert(:category, v_internet)
insert(:category, v_dsl)
insert(:category, v_phone)
insert(:category, v_m)


o_i = %{name: "Internet", vendor: o2}
o_d = %{name: "DSL", vendor: o2}
insert(:category,o_i)
insert(:category,o_d)


vat_elec = %{name: "Electricity", vendor: vattenfall}
vat_gas = %{name: "Gas", vendor: vattenfall}
insert(:category, vat_elec)
insert(:category, vat_gas)

m_g = %{name: "Gym", vendor: mcfit}
insert(:category, m_g)

s_t = %{name: "Paid Tv", vendor: sky}
insert(:category, s_t)
