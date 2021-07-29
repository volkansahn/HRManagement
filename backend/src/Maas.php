<?php


namespace Src;


class Maas
{

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function findAll()
    {
        $statement = "
            SELECT 
                *
            FROM
                maas;
        ";

        try {
            $statement = $this->db->query($statement);
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function find($kullanici_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                maas
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $kullanici_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function insert(array $input)
    {
        $statement = "
            INSERT INTO maas 
                (maas, yan_odemeler)
            VALUES
                (:maas, :yan_odemeler)
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'maas' => $input['maas'],
                'yan_odemeler' => $input['yan_odemeler'],
                'kullanici_id' => $input['kullanici_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function update($kullanici_id, array $input)
    {
        $statement = "
            UPDATE maas
            SET 
                maas = :maas, 
                yan_odemeler = :yan_odemeler
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $kullanici_id,
                'maas' => $input['maas'],
                'yan_odemeler' => $input['yan_odemeler']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function delete($amir_id)
    {
        $statement = "
            DELETE FROM amir
            WHERE amir_id = :amir_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array('rol_id' => $amir_id));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }
}