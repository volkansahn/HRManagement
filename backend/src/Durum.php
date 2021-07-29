<?php


namespace Src;


class Durum
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
                durum;
        ";

        try {
            $statement = $this->db->query($statement);
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function find($durum_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                durum
            WHERE durum_id = :durum_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'durum_id' => $durum_id
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
            INSERT INTO amir 
                (amir_id, kullanici_id)
            VALUES
                (:amir_id, :kullanici_id);
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'amir_id' => $input['amir_id'],
                'kullanici_id' => $input['kullanici_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function update($amir_id, array $input)
    {
        $statement = "
            UPDATE amir
            SET 
                kullanici_id = :kullanici_id
            WHERE amir_id = :amir_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'amir_id' => $amir_id,
                'kullanici_id' => $input['kullanici_id']
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